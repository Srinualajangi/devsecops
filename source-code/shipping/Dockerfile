#Build

FROM maven AS build

WORKDIR /opt/shipping

COPY pom.xml /opt/shipping/
RUN mvn dependency:resolve
COPY src /opt/shipping/src/
RUN mvn package

#
# Run
#
FROM amazoncorretto:8-alpine-jdk

EXPOSE 8080

WORKDIR /opt/shipping

COPY --from=build /opt/shipping/target/shipping-*.jar shipping.jar

CMD [ "java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar" ]