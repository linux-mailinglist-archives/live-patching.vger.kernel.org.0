Return-Path: <live-patching+bounces-845-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BAA49D1160
	for <lists+live-patching@lfdr.de>; Mon, 18 Nov 2024 14:06:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11A18283E22
	for <lists+live-patching@lfdr.de>; Mon, 18 Nov 2024 13:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AEDF1B394F;
	Mon, 18 Nov 2024 13:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I4xI+4NR"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CF119AD7E
	for <live-patching@vger.kernel.org>; Mon, 18 Nov 2024 13:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731935066; cv=none; b=I42nARWoHQfyOfc9vLatY6AkYsRvlEW551qEEry92LNqPA2rlDOdXNhh8H9UGRoLYfe2h8jvs09UGDxVaaY8GBdf4ELaP0rGMqjEy/afpGZIiYxYMGZmNcZa2fx6XM2ZbJAbQnCCQbPBA+3YVtkPY7b4DzkJBzgEACfnGmx9gFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731935066; c=relaxed/simple;
	bh=6FWzUYWFCrsnvBdRA5DjNCEJdOaye5Th9KK3CZXgcSI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZdtyD4Ydm8oRpYDVtc3R765nPiJ9xCXS+3M94GCehNpYdym/DuKBonoYJVxrfkxuqGtL1QveDdm6sA1sAh1KAlulRcI+H6LVFlC30LoG5Wr8t/RffTN15T7gdFu2TQhfqkoC8v6PlzcbrF9ImCeXcfGSsHyfSHRXdCtSetrWPK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I4xI+4NR; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43162cf1eaaso29456045e9.0
        for <live-patching@vger.kernel.org>; Mon, 18 Nov 2024 05:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731935062; x=1732539862; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GxWmoEeugVS1v5FyiW6L+8vxmWvgvGVYr+32bhSNYVY=;
        b=I4xI+4NRNwIdqEl4aflVO7Kmj0AcLq/HsTkPdfNSTzP/xkuJTfQaW0ozzMQWPVtMrm
         /phHSN7AC2S3XrUHAFRlKqK0UVzBM0fS4t4KUXcol1Pp8PChXmX3A3V8eSSvRQqHO/kf
         owQ1Hiaqep96yfg3F+hPCYjOs/OmlLVant5SicgiwXt0a5kOgTBPDfYAu8QOre9PRqcB
         qrLYcmIkN7U9BgRB8QzTSSXJ5Zru26knyWezZAfrAhBonrCj2uD2v5IEEULTbpdHqHuB
         8GDP8F5+QNobc9LalJArdeO/8kzv5O0I+9bQug0bxmmjdNSJQGSvaBP1KOqCP1pzC3iK
         4alA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731935062; x=1732539862;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GxWmoEeugVS1v5FyiW6L+8vxmWvgvGVYr+32bhSNYVY=;
        b=kNae0mEF1Rh+mNYbxPcey2EZpeQCJfBzsH2PEO8YtEKqOlPehogIENsXXVYLt5zitk
         ca6iTJoLwtwd7KQxFzYFskc9YWD+fv2jFzL+cHAYz7kFrBLZGGKMp188+HgzwbO9qnD1
         O146mfMJ2ZUR79bMtTynmgarqizncOZ7jqSDjQmuH4QKZ7Wvn7hsb0oPKmKzsrqvunwg
         lZbYtnGSPPiSIrP7Q9bJQptn8vGon1XhNTZz0AfNtjKjNqwHfUJt+P3B6xdH0G0j4QTj
         umK4WdtVspIpDU1h4kQitLn8wnCrtuOhewj7c1MvklybPSnyQf3aEWPwvJfVYF5Od6+t
         0Qvg==
X-Forwarded-Encrypted: i=1; AJvYcCWXoemaLKdO+YHopyg2aRSjcuEW46HCPTrqVOcD1nSZ8AwfMqy0CkIUOWBTcpIIxTVeLPG4d/SZZ6cT2k5c@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0LNSlad4UzON3/zpxZT3A6dqmIODpvoaFgKrWwbhvyEWslyxV
	8iR1Qd6xRFdGqXGxj5fQ6DIHydlkVwS/Mn1yV/xWVhb3wsQvcH9J+caPgUaqMLd06OYXtiWdMSI
	cL5w=
X-Google-Smtp-Source: AGHT+IHy/xNjbMBwdkC38nxZZYbLABoxkMezarb7il7wix1uC6BXNWVekYNhmn0yGD3yIBODDTuVhA==
X-Received: by 2002:a5d:5850:0:b0:382:24b1:e762 with SMTP id ffacd0b85a97d-38225ac4bb6mr12329038f8f.56.1731935062634;
        Mon, 18 Nov 2024 05:04:22 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382455820absm3879797f8f.84.2024.11.18.05.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 05:04:22 -0800 (PST)
Date: Mon, 18 Nov 2024 14:04:19 +0100
From: Petr Mladek <pmladek@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 6.13
Message-ID: <Zzs7U8VsO8YmxxD4@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

please pull the latest changes for the kernel livepatching from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.13

=============================================

- A new selftest for livepatching of a kprobed function.

----------------------------------------------------------------
Michael Vetter (3):
      selftests: livepatch: rename KLP_SYSFS_DIR to SYSFS_KLP_DIR
      selftests: livepatch: save and restore kprobe state
      selftests: livepatch: test livepatching a kprobed function

 tools/testing/selftests/livepatch/Makefile         |  3 +-
 tools/testing/selftests/livepatch/functions.sh     | 29 ++++++----
 .../testing/selftests/livepatch/test-callbacks.sh  | 24 ++++-----
 tools/testing/selftests/livepatch/test-ftrace.sh   |  2 +-
 tools/testing/selftests/livepatch/test-kprobe.sh   | 62 ++++++++++++++++++++++
 .../testing/selftests/livepatch/test-livepatch.sh  | 12 ++---
 tools/testing/selftests/livepatch/test-state.sh    |  8 +--
 tools/testing/selftests/livepatch/test-syscall.sh  |  6 +--
 tools/testing/selftests/livepatch/test-sysfs.sh    |  8 +--
 .../selftests/livepatch/test_modules/Makefile      |  3 +-
 .../livepatch/test_modules/test_klp_kprobe.c       | 38 +++++++++++++
 11 files changed, 152 insertions(+), 43 deletions(-)
 create mode 100755 tools/testing/selftests/livepatch/test-kprobe.sh
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_kprobe.c

