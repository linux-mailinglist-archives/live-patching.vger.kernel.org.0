Return-Path: <live-patching+bounces-975-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 40CD3A11BC3
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:24:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 960CF7A03E9
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C525C22FDF7;
	Wed, 15 Jan 2025 08:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BioyUxEE";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BioyUxEE"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA511EBFE8;
	Wed, 15 Jan 2025 08:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929486; cv=none; b=Ei2Xy0LxNAh6EchGftRPyui/7hzvozutyj9LfbTym3I0XOw6KVT8jh7xnQ5KkmkRx4I7w0LOF3riA1/QhRWupWfj3vguKmuE9RnHdMFgfVpkESqlPn45vMOrAFOXKoi7qtWu4vzEfu6tgbOGP4h5yKL74WEBCgwfu7KD7BRq/ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929486; c=relaxed/simple;
	bh=mPlPFKgHd7bB4pL07ZVZcuyY3Ykg/rR8vPGOTGsa+J8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H8UExhAVH5GLyfbgdMpMaw2cE3CJtrgrkI5qehxkWB1Z5Wsprhjiacm98ouBnSSWcGsEWOGVyjOxH1Cv3LMzGv8AXvLIZjx1lk0p+2s9OgkDQ7w03Sg4E1wrdueWSbRREuULGzEgeA3M/dm0uWYAxT0sgNwa0MXTEdzNrxIQ0hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BioyUxEE; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BioyUxEE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 489461F37C;
	Wed, 15 Jan 2025 08:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5N46FHw8QKSsP/PkWerjSspiCBmroSt8n417oAPjWWw=;
	b=BioyUxEE4FV0AOy+m2kChAtCVNWpJowkr1SXN/GjDG3TJLcjeYOzGOu6FpGWMj5TDIgPf6
	XDWFTh1xaPp1vWhtTducBTF3Q4goYPBh4SiZWMUcy5MGoG8Vku7kco174m2XqvP8ac7kbN
	fnvH/gHmet0BQMImcQob5W0eanW+hkc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5N46FHw8QKSsP/PkWerjSspiCBmroSt8n417oAPjWWw=;
	b=BioyUxEE4FV0AOy+m2kChAtCVNWpJowkr1SXN/GjDG3TJLcjeYOzGOu6FpGWMj5TDIgPf6
	XDWFTh1xaPp1vWhtTducBTF3Q4goYPBh4SiZWMUcy5MGoG8Vku7kco174m2XqvP8ac7kbN
	fnvH/gHmet0BQMImcQob5W0eanW+hkc=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 00/19] livepatch: Better integrate callbacks and shadow variables with the states API
Date: Wed, 15 Jan 2025 09:24:12 +0100
Message-ID: <20250115082431.5550-1-pmladek@suse.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid]
X-Spam-Score: -3.30
X-Spam-Flag: NO

Hi there,

this patchset is based on POC which I have sent before
Linus Plumbers 2013 and presented it there, see
https://lore.kernel.org/r/20231110170428.6664-1-pmladek@suse.com

The aim is to help maintaining lifetime of changes made by livepatch
callbacks and shadow variables.

Key changes include:

- Per-state callbacks replace per-object callbacks, invoked only when a
  livepatch introduces or removes a state.
- Shadow variable lifetime is now tied to the corresponding livepatch
  state lifetime.
- The "version" field in `struct klp_state` has been replaced with the
  "block_disable" flag for improved compatibility handling.
- The "data" field has been removed from `struct klp_state`; shadow
  variables are now the recommended way to store state-related data.


Open question:

Shadow variables are connected with the state only when state.is_shadow
is set. It might make sense to always connect shadow variables with
the state using the same "id".

It would simplify the semantic and use. But it might be error prone
when shadow variables are connected with a state by mistake.

It might get improved when we allow to create a shadow variable only
when a patch supporting the state with the same "id" is (being)
registered.


Motivation:

The basic livepatch functionality is to redirect problematic functions
to a fixed or improved variants. In addition, there are two features
helping with more problematic situations:

  + pre_patch(), post_patch(), pre_unpatch(), post_unpatch() callbacks
    might be called before and after the respective transitions.
    For example, post_patch() callback might enable some functionality
    at the end of the transition when the entire system is using
    the new code.

  + Shadow variables allow to add new items into structures or other
    data objects.

The practice has shown that these features were hard to use with the atomic
replace feature. The new livepatch usually just adds more fixes. But it
might also remove problematic ones.

Originally, any version of the livepatch was allowed to replace any older
or newer version of the patch. It was not clear how to handle the extra
features. The new patch did not know whether to run the callbacks or
if the changes were already done by the current livepatch. Or if it has
to revert some changes or free shadow variables whey they would no longer
be supported.

It was even more complicated because only the callbacks from the newly
installed livepatch were called. It means that older livepatch might
not be able to revert changes supported only by newer livepatches.

The above problems were supposed to be solved by adding livepatch
states. Each livepatch might define which states are supported. The states
are versioned. The livepatch core checks if the newly installed livepatch
is able to handle all states used by the currently installed livepatch.

Though the practice has shown that the states API was not easy to use
either. It was not well connected with the callbacks and shadow variables.
The states are per-patch. The callbacks are per-object. The livepatch
does not know about the supported shadow variables at all.


Changes against POC:

  + Renamed callbacks back to pre_patch, post_patch, pre_unpatch,
    and post_unpatch [Josh]
  + Remove .version field completely [Miroslav]
  + Removed .data field
  + Fixed the use of "atomic replace" vs. "cumulative livepatch"
    terms [Miroslav]
  + Set .is_shadow in the test module modifying console_loglevel [Miroslav]
  + Revert pre_unpatch() callbacks when the transition is reverted. [Petr]
  + Improved and added selftests. Split into many patches [Petr]
  + Updated documentation [Petr]

[POC] https://lore.kernel.org/r/https://lore.kernel.org/r/20231110170428.6664-1-pmladek@suse.com

Base commit: c45323b7560ec87c37c729b703c86ee65f136d75 (6.13-rc7+)

Petr Mladek (19):
  livepatch: Add callbacks for introducing and removing  states
  livepatch: Allow to handle lifetime of shadow variables using the
    livepatch state
  selftests/livepatch: Use per-state callbacks in state API tests
  livepatch: Add "block_disable" flag to per-state API and remove
    versioning
  livepatch: Remove "data" from struct klp_state
  selftests/livepatch: Remove callbacks from sysfs interface testing
  selftests/livepatch: Substitute hard-coded /sys/module path
  selftests/livepatch: Move basic tests for livepatching modules
  selftests/livepatch: Convert testing of multiple target modules
  selftests/livepatch: Create a simple selftest for state callbacks
  selftests/livepatch: Convert selftests for failing pre_patch callback
  selftests/livepatch: Convert selftest with blocked transition
  selftests/livepatch: Add more tests for state callbacks with blocked
    transitions
  selftests/livepatch: Convert selftests for testing callbacks with more
    livepatches
  selftests/livepatch: Do not use a livepatch with the obsolete
    per-object callbacks in the basic selftests
  selftests/livepatch: Remove obsolete test modules for per-object
    callbacks
  samples/livepatch: Replace sample module with obsolete per-object
    callbacks
  Documentation/livepatch: Update documentation for state, callbacks,
    and shadow variables
  livepatch: Remove obsolete per-object callbacks

 Documentation/livepatch/api.rst               |   2 +-
 Documentation/livepatch/callbacks.rst         | 166 +++---
 Documentation/livepatch/index.rst             |   4 +-
 Documentation/livepatch/shadow-vars.rst       |  47 +-
 Documentation/livepatch/system-state.rst      | 208 +++----
 include/linux/livepatch.h                     |  81 +--
 kernel/livepatch/core.c                       |  43 +-
 kernel/livepatch/core.h                       |  33 --
 kernel/livepatch/state.c                      | 179 +++++-
 kernel/livepatch/state.h                      |   9 +
 kernel/livepatch/transition.c                 |  20 +-
 samples/livepatch/Makefile                    |   5 +-
 .../livepatch/livepatch-callbacks-busymod.c   |  60 --
 samples/livepatch/livepatch-callbacks-demo.c  | 196 -------
 samples/livepatch/livepatch-callbacks-mod.c   |  41 --
 samples/livepatch/livepatch-speaker-fix.c     | 376 ++++++++++++
 samples/livepatch/livepatch-speaker-mod.c     | 203 +++++++
 samples/livepatch/livepatch-speaker.h         |  15 +
 tools/testing/selftests/livepatch/Makefile    |   2 +
 .../testing/selftests/livepatch/functions.sh  |  75 ++-
 .../selftests/livepatch/test-callbacks.sh     | 553 ------------------
 .../selftests/livepatch/test-livepatch.sh     |   4 +-
 .../testing/selftests/livepatch/test-order.sh | 295 ++++++++++
 .../livepatch/test-state-callbacks.sh         | 451 ++++++++++++++
 .../testing/selftests/livepatch/test-state.sh |  86 ++-
 .../testing/selftests/livepatch/test-sysfs.sh |  48 +-
 .../selftests/livepatch/test_modules/Makefile |   8 +-
 .../test_modules/test_klp_callbacks_busy.c    |  70 ---
 .../test_modules/test_klp_callbacks_demo.c    | 121 ----
 .../test_modules/test_klp_callbacks_demo2.c   |  93 ---
 .../test_modules/test_klp_callbacks_mod.c     |  24 -
 .../livepatch/test_modules/test_klp_speaker.c | 203 +++++++
 .../livepatch/test_modules/test_klp_speaker.h |  15 +
 .../test_modules/test_klp_speaker2.c          |   8 +
 .../test_modules/test_klp_speaker_livepatch.c | 407 +++++++++++++
 .../test_klp_speaker_livepatch2.c             |   5 +
 .../livepatch/test_modules/test_klp_state.c   | 143 ++---
 .../livepatch/test_modules/test_klp_state2.c  | 190 +-----
 .../livepatch/test_modules/test_klp_state3.c  |   2 +-
 39 files changed, 2664 insertions(+), 1827 deletions(-)
 delete mode 100644 samples/livepatch/livepatch-callbacks-busymod.c
 delete mode 100644 samples/livepatch/livepatch-callbacks-demo.c
 delete mode 100644 samples/livepatch/livepatch-callbacks-mod.c
 create mode 100644 samples/livepatch/livepatch-speaker-fix.c
 create mode 100644 samples/livepatch/livepatch-speaker-mod.c
 create mode 100644 samples/livepatch/livepatch-speaker.h
 delete mode 100755 tools/testing/selftests/livepatch/test-callbacks.sh
 create mode 100755 tools/testing/selftests/livepatch/test-order.sh
 create mode 100755 tools/testing/selftests/livepatch/test-state-callbacks.sh
 delete mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_busy.c
 delete mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo.c
 delete mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo2.c
 delete mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_mod.c
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_speaker.h
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_speaker2.c
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch2.c

-- 
2.47.1


