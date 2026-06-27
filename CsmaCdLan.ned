//
// Mô hình mạng CSMA/CD cho đồ án Mạng máy tính.
// N trạm EthernetHost nối chung vào một EthernetHub => MỘT miền đụng độ dùng chung.
// EthernetHost của INET đã bật CSMA/CD half-duplex sẵn,
// nên khi nối qua hub là cảm nhận sóng mang + phát hiện đụng độ + backoff hoạt động.
//

import inet.node.ethernet.EthernetHost;
import inet.node.ethernet.EthernetHub;

//
// Cáp Ethernet dùng chung.
//   datarate = tốc độ kênh R   -> thời gian truyền 1 frame: T = (số bit frame) / R
//   delay    = trễ lan truyền τ -> τ = (chiều dài cáp) / (tốc độ tín hiệu ~2e8 m/s)
// Biến chốt của CSMA/CD là a = τ / T.
//
channel EthCable extends ned.DatarateChannel
{
    datarate = default(10Mbps);
    delay = default(0.5us);       // ~100 m (100 / 2e8 = 0.5us)
}

network CsmaCdLan
{
    parameters:
        int numHosts = default(10);
        @display("bgb=1000,1000");          // nền lớn hơn để vòng host lọt vào trong
    submodules:
        hub: EthernetHub {
            @display("p=0,0");          // hub ở chính giữa nền
        }
        host[numHosts]: EthernetHost {
            @display("p=500,500,ring");      // các host xếp vòng quanh tâm giữa
        }
    connections:
        for i=0..numHosts-1 {
            host[i].ethg <--> EthCable <--> hub.ethg++;
        }
}
