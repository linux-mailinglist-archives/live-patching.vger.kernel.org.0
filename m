Return-Path: <live-patching+bounces-31-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D50F17E7DF5
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 18:04:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAC681C209A3
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 17:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2F81DFF6;
	Fri, 10 Nov 2023 17:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ufL3/mwT"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7B563B4
	for <live-patching@vger.kernel.org>; Fri, 10 Nov 2023 17:04:49 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B97842C3B;
	Fri, 10 Nov 2023 09:04:48 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 70A551F8BB;
	Fri, 10 Nov 2023 17:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1699635886; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Gco73RSfTN8/boy1pLt5p6ChVwATofQd6fACfgYTWTQ=;
	b=ufL3/mwTE+4mCIbIPd+1IEJW7k2lVhoUQMg21AwxEphiSdKftZ1sKZIMUpFvumAf9vpcsb
	hyzlerKcwXy2CL2wx9b8skryI3QTq/8AQ8w3t+b/4bANpuir9D4TQdu0IDW5DvcnBTGLg+
	7Gli9bzuFUNAaDoQ4c4DStgAyBVoX0A=
Received: from alley.suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
	by relay2.suse.de (Postfix) with ESMTP id 12A182C289;
	Fri, 10 Nov 2023 17:04:46 +0000 (UTC)
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [POC 0/7] livepatch: Make livepatch states, callbacks, and shadow variables work together
Date: Fri, 10 Nov 2023 18:04:21 +0100
Message-Id: <20231110170428.6664-1-pmladek@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This POC is a material for the discussion "Simplify Livepatch Callbacks,
Shadow Variables, and States handling" at LPC 2013, see
https://lpc.events/event/17/contributions/1541/

It obsoletes the patchset adding the garbage collection of shadow
variables. This new solution is based on ideas from Nicolai Stange.
And it should also be in sync with Josh's ideas mentioned into
the thread about the garbage collection, see
https://lore.kernel.org/r/20230204235910.4j4ame5ntqogqi7m@treble

What is this all about?

There are three features provided by the kernel livepatching support:

  + callbacks:

       They allow doing system modifications where the "simple"
       redirection to the fixed code is not enough. For example,
       allocate some data and allow to use them when all processes
       are patched.

       There are four optional callbacks which might be called
       either when the livepatch or the livepatched object is loaded.
       It depends who is loaded first.

       The are called at different stages of the livepatch transition:
       pre_enable, post_enable, pre_disable, post_disable.

       Only callbacks from the new livepatch are called during atomic
       replace. The motivation was that new livepatches should know
       how to handle the existing changes correctly. Also it
       simplified the semantic because it would be horrible when
       both callbacks from the old and new livepatch are called.
       The later one might break changes done by the earlier one.

       They are defined per-object. The idea was that they might
       be needed when a livepatched module is loaded or unloaded.


   + shadow variables:

      They allow attaching extra data to any existing data.
      For example, they allow to extend a structure. Or they
      allow to create a spin lock which might stay even
      when the livepatch gets atomically replaced.

      They are defined per-patch but there is no real connection.
      There is just an allocate/get/free API.


   + states:

      They were introduced to manage the life-cycle of changes
      done by the callbacks and shadow variables.

      They should help especially when atomic replace is used.
      The new livepatch need to know what changes have already
      been done or which need to be reverted.

      The states are defined per-patch. There was proposal
      to make them per-object but it was decided that it
      was not worth the complexity.

      Each state might have a version which allows to maintain
      compatibility between the livepatches. Otherwise, there
      is no connection with the other features. The is just an API
      to check whether the state was in the previous patch so that
      the callbacks might do an informed decisions.


Observation:

   + States were supposed to help with the life-time of changes
     done by callbacks. But states are per-patch and callbacks
     are per-object. Also the API is hard to use.

   + Shadow variables were not connected with the states at all.
     It needs to be done by callbacks.

   + The decision that only the callbacks from the new livepatch
     gets called during atomic replace make downgrades complicated.


Better solution implemented by this POC:

   + Transform per-object callbacks to per-state callbacks
     so that the state might really control the life-cycle
     of the changes.

   + Change the semantic of the callbacks, so that they
     are called when the state is introduced or removed.

     No callbacks are called when the state is just transferred
     during the atomic replace.


   + The disable/remove callbacks from the old livepatch are
     called from the old livepatch when the new one does
     not support them.

     These callbacks have to be there anyway so that the livepatch
     can get disabled.

     This nicely solves the problem with downgrades while keeping
     simple semantic.


   + A state might be associated with a shadow variable with
     the same ID.

     It helps to maintain the life-cycle of the shadow variable.

     The variable is automatically freed when the state is not longer
     supported during atomic replace or when the livepatch gets disabled.

     Also the state callbacks might help to allocate the variable
     do do some checks before the transition starts. But it can
     be enabled only after all processes are transitioned.

     It would prevent loading the livepatch when the shadow variable
     could not be used and the livepatch could cause problems.


   + State version is replaced with "block_disable" flag.

     The versions are too generic and make things complicated.

     In practice, the main question is whether the changes introduced
     by the state (callbacks) can be reverted or not. The livepatch
     could not be disabled or downgraded when the revert (state disable)
     is not supported.


What is done in this POC:

   + All changes in livepatch code are implemented.
   + The existing selftests are migrated [*]


What is missing:

   + The documentation is not updated.
   + More selftest might be needed [**]


[*] There is some mystery in a selftest when the migration gets
    blocked, see the comments in the 5th patch.

[**] In fact, many selftests would deserve some cleanup and 
     better split into categories.


Petr Mladek (7):
  livepatch: Add callbacks for introducing and removing states
  livepatch: Allow to handle lifetime of shadow variables using the
    livepatch state
  livepatch: Use per-state callbacks in state API tests
  livepatch: Do not use callbacks when testing sysfs interface
  livepatch: Convert klp module callbacks tests into livepatch module
    tests
  livepatch: Remove the obsolete per-object callbacks
  livepatching: Remove per-state version

 Documentation/livepatch/callbacks.rst         | 133 -----
 Documentation/livepatch/index.rst             |   1 -
 include/linux/livepatch.h                     |  75 ++-
 kernel/livepatch/core.c                       |  61 +-
 kernel/livepatch/core.h                       |  33 --
 kernel/livepatch/state.c                      | 151 ++++-
 kernel/livepatch/state.h                      |  10 +
 kernel/livepatch/transition.c                 |  13 +-
 lib/livepatch/Makefile                        |   8 +-
 lib/livepatch/test_klp_callbacks_busy.c       |  70 ---
 lib/livepatch/test_klp_callbacks_demo.c       | 121 ----
 lib/livepatch/test_klp_callbacks_demo2.c      |  93 ---
 lib/livepatch/test_klp_callbacks_mod.c        |  24 -
 lib/livepatch/test_klp_speaker.c              | 185 ++++++
 lib/livepatch/test_klp_speaker_livepatch.c    | 253 ++++++++
 lib/livepatch/test_klp_state.c                | 178 ++++--
 lib/livepatch/test_klp_state2.c               | 190 +-----
 lib/livepatch/test_klp_state3.c               |   2 +-
 samples/livepatch/Makefile                    |   3 -
 .../livepatch/livepatch-callbacks-busymod.c   |  60 --
 samples/livepatch/livepatch-callbacks-demo.c  | 196 -------
 samples/livepatch/livepatch-callbacks-mod.c   |  41 --
 tools/testing/selftests/livepatch/Makefile    |   2 +-
 .../testing/selftests/livepatch/functions.sh  |  46 ++
 .../selftests/livepatch/test-callbacks.sh     | 553 ------------------
 .../selftests/livepatch/test-modules.sh       | 539 +++++++++++++++++
 .../testing/selftests/livepatch/test-state.sh |  80 ++-
 .../testing/selftests/livepatch/test-sysfs.sh |  48 +-
 28 files changed, 1436 insertions(+), 1733 deletions(-)
 delete mode 100644 Documentation/livepatch/callbacks.rst
 delete mode 100644 lib/livepatch/test_klp_callbacks_busy.c
 delete mode 100644 lib/livepatch/test_klp_callbacks_demo.c
 delete mode 100644 lib/livepatch/test_klp_callbacks_demo2.c
 delete mode 100644 lib/livepatch/test_klp_callbacks_mod.c
 create mode 100644 lib/livepatch/test_klp_speaker.c
 create mode 100644 lib/livepatch/test_klp_speaker_livepatch.c
 delete mode 100644 samples/livepatch/livepatch-callbacks-busymod.c
 delete mode 100644 samples/livepatch/livepatch-callbacks-demo.c
 delete mode 100644 samples/livepatch/livepatch-callbacks-mod.c
 delete mode 100755 tools/testing/selftests/livepatch/test-callbacks.sh
 create mode 100755 tools/testing/selftests/livepatch/test-modules.sh

-- 
2.35.3


