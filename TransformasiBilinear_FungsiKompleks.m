% Parameter untuk area berbayang awal di bidang z
x_min = 0; x_max = 1;
y_min = -1; y_max = 1;

% Parameter untuk lingkaran di bidang zeta (fase transisi 2)
circle_center_zeta = [0.5, 0]; % Pusat lingkaran kecil
circle_radius_zeta = 0.5; % Jari-jari lingkaran kecil

% Parameter untuk lingkaran di bidang w (fase akhir)
circle_center_w = [0, 0]; % Pusat lingkaran di asal
circle_radius_w = 1; % Jari-jari lingkaran satuan

% Jumlah frame untuk animasi
num_frames = 150; % Total frame (dibagi merata di setiap fase)
theta = linspace(0, 2 * pi, 100); % Sudut untuk lingkaran

% Membuat figura untuk animasi
figure;

% Loop untuk semua transformasi
for k = 1:num_frames
    % Bersihkan plot sebelumnya
    clf;
    hold on;

    % Definisikan fase animasi
    if k <= num_frames / 3
        % **Fase 1: Transformasi Linear z -> zeta**
        % Rotasi, dilatasi, dan translasi diterapkan di sini
        shift = (k - 1) / (num_frames / 3); % Faktor interpolasi untuk translasi
        % Perpindahan persegi panjang di bidang zeta
        rectangle('Position', [x_min + shift, y_min, x_max - x_min, y_max - y_min], ...
                  'FaceColor', [0.8, 0.4, 0.4], 'EdgeColor', 'none'); % Merah

        % Gambarkan garis putus-putus vertikal di x=1 setelah persegi panjang berhenti
        if k == num_frames / 3
            line([1 1], [-2 2], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
        end

    elseif k <= 2 * num_frames / 3
        % **Fase 2: Transformasi Balikkan zeta -> xi**
        % Persegi panjang di bidang zeta berubah menjadi lingkaran kecil
        t = (k - num_frames / 3) / (num_frames / 3); % Faktor interpolasi

        % Buat titik-titik untuk persegi panjang dan lingkaran
        num_points = 200; % Jumlah titik untuk bentuk
        angle_step = linspace(0, 2 * pi, num_points);

        % Definisikan simpul persegi panjang
        rect_x = [1, 2, 2, 1, 1]; % Koordinat x persegi panjang
        rect_y = [-1, -1, 1, 1, -1]; % Koordinat y persegi panjang

        % Pemetaan titik persegi panjang ke transisi halus menuju lingkaran
        transition_x = zeros(1, num_points);
        transition_y = zeros(1, num_points);
        for i = 1:num_points
            angle = angle_step(i); % Sudut saat ini

            % Interpolasi titik persegi panjang
            rect_interp_x = interp1(linspace(0, 2 * pi, 5), rect_x, angle, 'linear');
            rect_interp_y = interp1(linspace(0, 2 * pi, 5), rect_y, angle, 'linear');

            % Transisi dari persegi panjang ke lingkaran
            transition_x(i) = (1 - t) * rect_interp_x + t * (circle_radius_zeta * cos(angle) + circle_center_zeta(1));
            transition_y(i) = (1 - t) * rect_interp_y + t * (circle_radius_zeta * sin(angle) + circle_center_zeta(2));
        end

        % Gambarkan bentuk transisi
        fill(transition_x, transition_y, [0.6, 0.7, 0.8], 'EdgeColor', 'none');

    else
        % **Fase 3: Transformasi Linear xi -> w**
        % Lingkaran kecil diperbesar menjadi lingkaran satuan
        t = (k - 2 * num_frames / 3) / (num_frames / 3); % Faktor interpolasi
        radius = circle_radius_zeta + t * (circle_radius_w - circle_radius_zeta); % Radius yang diinterpolasi
        center_x = circle_center_zeta(1) * (1 - t) + circle_center_w(1) * t; % Pusat yang diinterpolasi
        x_circle_w = radius * cos(theta) + center_x;
        y_circle_w = radius * sin(theta);
        fill(x_circle_w, y_circle_w, [0.6, 0.5, 0.8], 'EdgeColor', 'none'); % Lingkaran ungu
    end

    % Sumbu dan label
    line([-2 2], [0 0], 'Color', 'k'); % Sumbu x
    line([0 0], [-2 2], 'Color', 'k'); % Sumbu y
    text(1.1, -0.1, '1', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'center');
    text(-1.1, -0.1, '-1', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'center');
    text(-0.1, 1.1, 'i', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    text(-0.1, -1.1, '-i', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');
    title('Transformasi Bilinear: $z \to \zeta \to \xi \to w$', 'Interpreter', 'latex');
    axis equal; % Rasio aspek 1:1
    axis([-2 2 -2 2]);
    
    % Perbarui plot
    pause(0.1);
end
