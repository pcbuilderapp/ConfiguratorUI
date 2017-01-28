import 'dart:html';
import 'package:pcbuilder.api/transport/configuration.dart';

class BuyOverviewDialog {
  Element _dialogElement;

  BuyOverviewDialog() {
    _dialogElement = querySelector("#buyOverviewDialog");
    _dialogElement.querySelector(".closeBtn").onClick.listen((_) {
      close();
    });
  }

  void show(Configuration configuration) {
    Element content = _dialogElement.querySelector(".content");
    content.innerHtml = "";

    if (configuration.motherboard == null ||
        configuration.cpu == null ||
        configuration.gpu == null ||
        configuration.memory == null ||
        configuration.storage == null ||
        configuration.psu == null ||
        configuration.casing == null) {
      window.alert("Configuration incomplete.");
      return;
    }

    content.append(new Element.p()..classes.add("item")
      ..append(new Element.div()
        ..style.backgroundImage = "url(${configuration.motherboard.image})"
        ..classes.add("image"))
      ..append(new Element.a()
        ..text = configuration.motherboard.name
        ..attributes["href"] = configuration.motherboard.url
        ..attributes["target"] = "_blank"
        ..classes.add("name"))
        );

    content.append(new Element.p()..classes.add("item")
      ..append(new Element.div()
        ..style.backgroundImage = "url(${configuration.cpu.image})"
        ..classes.add("image"))
      ..append(new Element.a()
        ..text = configuration.cpu.name
        ..attributes["href"] = configuration.cpu.url
        ..attributes["target"] = "_blank"
        ..classes.add("name"))
    );

    content.append(new Element.p()..classes.add("item")
      ..append(new Element.div()
        ..style.backgroundImage = "url(${configuration.gpu.image})"
        ..classes.add("image"))
      ..append(new Element.a()
        ..text = configuration.gpu.name
        ..attributes["href"] = configuration.gpu.url
        ..attributes["target"] = "_blank"
        ..classes.add("name"))
    );

    content.append(new Element.p()..classes.add("item")
      ..append(new Element.div()
        ..style.backgroundImage = "url(${configuration.memory.image})"
        ..classes.add("image"))
      ..append(new Element.a()
        ..text = configuration.memory.name
        ..attributes["href"] = configuration.memory.url
        ..attributes["target"] = "_blank"
        ..classes.add("name"))
    );

    content.append(new Element.p()..classes.add("item")
      ..append(new Element.div()
        ..style.backgroundImage = "url(${configuration.storage.image})"
        ..classes.add("image"))
      ..append(new Element.a()
        ..text = configuration.storage.name
        ..attributes["href"] = configuration.storage.url
        ..attributes["target"] = "_blank"
        ..classes.add("name"))
    );

    content.append(new Element.p()..classes.add("item")
      ..append(new Element.div()
        ..style.backgroundImage = "url(${configuration.psu.image})"
        ..classes.add("image"))
      ..append(new Element.a()
        ..text = configuration.psu.name
        ..attributes["href"] = configuration.psu.url
        ..attributes["target"] = "_blank"
        ..classes.add("name"))
    );

    content.append(new Element.p()..classes.add("item")
      ..append(new Element.div()
        ..style.backgroundImage = "url(${configuration.casing.image})"
        ..classes.add("image"))
      ..append(new Element.a()
        ..text = configuration.casing.name
        ..attributes["href"] = configuration.casing.url
        ..attributes["target"] = "_blank"
        ..classes.add("name"))
    );

    _dialogElement.parent.style.display = "flex";
    _dialogElement.style.display = "block";
  }

  void close() {
    _dialogElement.parent.style.display = "none";
    _dialogElement.style.display = "none";
  }
}
