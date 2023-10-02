FROM gitlab.praktikum-services.ru:5050/std-012-005/sausage-store/maven:3.8-openjdk-16 as builder
#Create build directory
ARG VERSION=${VERSION}
WORKDIR /usr/src/app
COPY . .
RUN mvn package

FROM gitlab.praktikum-services.ru:5050/std-012-005/sausage-store/openjdk:16

#Create app directory
WORKDIR /usr/src/app
ARG VERSION=${VERSION}
RUN curl https://storage.yandexcloud.net/cloud-certs/CA.pem -o YandexInternalRootCA.crt && \
    keytool -importcert -file YandexInternalRootCA.crt -alias yandex -cacerts -storepass changeit -noprompt && \
    rm -f YandexInternalRootCA.crt

COPY --from=builder /usr/src/app/target/sausage-store-report-${VERSION}.jar sausage-store-report.jar

ENTRYPOINT ["java", "-jar", "./sausage-store-report.jar"]
EXPOSE 8080
