import 'package:cached_network_image/cached_network_image.dart';
import 'package:elaichi/domain/repositories/events_repository.dart';
import 'package:elaichi/domain/repositories/user_repository.dart';
import 'package:elaichi/presentation/core/router/app_router.dart';
import 'package:elaichi/presentation/core/utils/sizeconfig.dart';
import 'package:elaichi/presentation/home/feed/widgets/webmail_card.dart';
import 'package:elaichi/presentation/home/fest/bloc/fest_bloc.dart';
import 'package:elaichi/presentation/home/fest/widgets/custom_draggable_sheet.dart';
import 'package:elaichi/presentation/home/fest/widgets/duration_dates.dart';
import 'package:elaichi/presentation/home/fest/widgets/featured_events.dart';
import 'package:elaichi/presentation/home/fest/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FestPage extends StatefulWidget {
  const FestPage({Key? key}) : super(key: key);

  @override
  State<FestPage> createState() => _FestPageState();
}

class _FestPageState extends State<FestPage> {
  late final FestBloc _bloc;

  @override
  void initState() {
    _bloc = FestBloc(
      eventRepository: context.read<EventRepository>(),
      userRepository: context.read<UserRepository>(),
    )..add(const FestEvent.started());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocBuilder<FestBloc, FestState>(
          builder: (context, state) {
            return state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error) {
                debugPrint(error);
                return const Center(child: Text('Something Went Wrong'));
              },
              initial: (webMailState, fests) {
                final fest = fests[0];
                return Stack(
                  children: [
                    HeaderWidget(
                      imageUrl: fest.coverImg ??
                          'https://res.cloudinary.com/dvkroz7wz/image/upload/v1667122918/SWW_1_vhkdpl.png',
                      leadingWidget: Text(
                        fest.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.white),
                      ),
                      trailingWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          SizeConfig.safeBlockHorizontal! * 10,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: fest.logo,
                          fit: BoxFit.fill,
                          placeholder: (context, url) =>
                              const Icon(Icons.circle),
                          height: 34,
                          width: 32,
                        ),
                      ),
                      bottomSubTitleWidget: const DurationDates(
                        text: 'Jan 03 - Jan 07 2023',
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      title: fest.name,
                      buttonTitle: 'Explore More',
                      onTapped: () async {
                        final calenderAndCategorisedEvents = await _bloc
                            .getCalenderAndCategorisedEvents(fest.id);
                        // ignore: use_build_context_synchronously
                        return Navigator.pushNamed(
                          context,
                          AppRouter.explore,
                          arguments: <String, dynamic>{
                            'fest': fest,
                            'categorisedEvents': calenderAndCategorisedEvents[
                                'categorisedEvents'],
                            'calender': calenderAndCategorisedEvents['calender']
                          },
                        );
                      },
                    ),
                    CustomDraggableSheet(
                      children: [
                        if (!_bloc.isVerified()) const WebMailCard(),
                        const FeaturedEvents(),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
