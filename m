Return-Path: <live-patching+bounces-264-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFCF28C6656
	for <lists+live-patching@lfdr.de>; Wed, 15 May 2024 14:25:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6447DB2330C
	for <lists+live-patching@lfdr.de>; Wed, 15 May 2024 12:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954D5763F1;
	Wed, 15 May 2024 12:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dGz7X5wx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F055A10B
	for <live-patching@vger.kernel.org>; Wed, 15 May 2024 12:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715775888; cv=none; b=mEje+J0LuTkcjR/+iCjvE97nginPU68Q4KVY9/Scm09HKIYblCWxR/64QeSach4bdHvRYiBgviyyHheQO7TaDXfBG2dlzpGytVXBT+3ltroTXeU4ifFNTyUvWop7lQROUyC9myVSuZIy/caB2oqql8iLOXqkhywxptfVScVHoF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715775888; c=relaxed/simple;
	bh=I26vxRg0Sm3JVFBxBEuZ+GowCZD0aQjHCSLl80qSBxs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DmkdtLXljWxZc+hdxfk+pHxkJ03rWqu+s83+nEtMdYd5NQsSZMk+3hu/rxT92+8yhi9f2LOERQAa8jAK+BSNlwT54jIS43vmESSj8J6tUN8h+m0EwIlmUUvtwwxe2/xBBnhLUCBNWR6MApcp5c0sWhLIE9HlhKPDG7PYzRverNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dGz7X5wx; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-572d83e3c7eso1733599a12.3
        for <live-patching@vger.kernel.org>; Wed, 15 May 2024 05:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1715775883; x=1716380683; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P6M7AXHWYgFp+anZ+3MDmxURX8URiX5ZduGDdYauJYk=;
        b=dGz7X5wxFwrMHzs6Z2/S35Bgt9y4ZmZQNloQ9g31DmzzSXH8x9pXybRWHZQiOkmozB
         Z7TgpIGsu9gVg0o1Sd0FcMftSc1IQIoKAGdaxSdwkz6/Ct6LjeiEnIc3kzRFktnOD799
         jHPrdXoB/APDUk+x3gOxMOrtgvAqtRR2aanitTqywROG2bHClVx08AnLIpwIM3GMolrs
         lcItEUtO0+24p1fgYCfU5tixdfrhSI194EKWy2l94rIPpcd68BvjdcyGBRPpn0vppNgr
         0MUP+me6FKRl9MjuYGBhamABR9l0Kswmp1xTjM5eyzKG324W3y4nlS/8ifMtySOJGw85
         52RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715775883; x=1716380683;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P6M7AXHWYgFp+anZ+3MDmxURX8URiX5ZduGDdYauJYk=;
        b=XPF4GX5wBx1LG+tq4duRncz6m2GJ0PMD+yGkOaYWNiKjQzb1gI7hnhtkTRmc5lrvaf
         RTwaLRjYsZxKLAG53O9eGLljf2aI4wvqr9f++fMc01Qudsf3zppytYMgbNH4QWfGblAX
         TpKs0p6jUxxYcLXwIsIQacBAkITqF85vR3y8CSFMJhtTIoiRUjxhkfky4ooHXWrFz/YK
         TcnK6aQu91LD6UHvbE9IDRxpdiZRdQ7xTRZp8hEZtKep9wSzRfOTwPtQ5zJizKIRxsEE
         lkJF7DOHUZkLZCUk7RRbFC5zFPsH2lzj44uk17zIzoInOLjxjq+iv3gcO71iCKf8LAvQ
         HOcg==
X-Forwarded-Encrypted: i=1; AJvYcCX5Gk4ne4xOyzuq7mccHbgCX76NOQuCWpnLqD5wCTsfkT2vc5m8OVj7yht1m5BcPLI1EuM80urH15Y9Lm7cldfyhsdACmhJmnHaGEsyQQ==
X-Gm-Message-State: AOJu0YwVs511h2/D6jmht/jLxl0rzUGEMNQyJTedh0/ii/Uh8q2P4axI
	nAeqkCubYa903dx35ehTc8W1VTBUeZp/DMnRzflRZ/rUPmQY6/7dFnr0YxKhGbw=
X-Google-Smtp-Source: AGHT+IEYNfUrv2/IkKempwARG+LxeAXOezDLELUSXDXLZzvO24ZghEbY+Byw8CnRJ8glbgmwC8HBrg==
X-Received: by 2002:a50:d5d2:0:b0:574:ea9d:51f3 with SMTP id 4fb4d7f45d1cf-574ea9d5459mr2726695a12.15.1715775883276;
        Wed, 15 May 2024 05:24:43 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5733c2cb52asm9035307a12.74.2024.05.15.05.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 05:24:42 -0700 (PDT)
Date: Wed, 15 May 2024 14:24:41 +0200
From: Petr Mladek <pmladek@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 6.10
Message-ID: <ZkSpicJYoMleJRkY@pathway.suse.cz>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.10

==========================================

- Use more informative names for the livepatch transition states.

----------------------------------------------------------------
Wardenjohn (1):
      livepatch: Rename KLP_* to KLP_TRANSITION_*

 include/linux/livepatch.h     |  6 ++---
 init/init_task.c              |  2 +-
 kernel/livepatch/core.c       |  4 ++--
 kernel/livepatch/patch.c      |  4 ++--
 kernel/livepatch/transition.c | 54 +++++++++++++++++++++----------------------
 5 files changed, 35 insertions(+), 35 deletions(-)

