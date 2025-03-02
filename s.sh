for i in `seq 1 500`
do
    echo $i
    ./antnode --rewards-address 0x9a4044317175baf04b7cd16bdd3132a6f8fc6601 evm-arbitrum-one &
    sleep 0.8
done
