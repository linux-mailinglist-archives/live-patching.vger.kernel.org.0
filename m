Return-Path: <live-patching+bounces-1445-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 664F5ABF274
	for <lists+live-patching@lfdr.de>; Wed, 21 May 2025 13:10:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9621189DA65
	for <lists+live-patching@lfdr.de>; Wed, 21 May 2025 11:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDA212609C2;
	Wed, 21 May 2025 11:10:11 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 946C146B5;
	Wed, 21 May 2025 11:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747825811; cv=none; b=gZWMw4NPD51h/kTT6igwXYWSE9RUmlXFB2lJmqYzAccohTE3Lh8oEJE5LJQM5Rf94Q6kUs1g3MaVn2/FUcGHfDIKkV3GY/tAtCtsL8eGdCWNH0YigKipEIWLamxwBCYRdvP1TUApK1lTJv5t2wYl9wV7ClPuCl0DFLAV49KFfzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747825811; c=relaxed/simple;
	bh=S7/JO3XY9lRsR54gwkB3Ior2y6g/Yr8EFkduDnhp33g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hlxJSLmvtrehcieur1wTq18qjB3mjrvsiQ4YHQvkMpSjqfQSgtQTGIa+x/Uc2a5JGtT6W9QZczGotIOxOc7JfWWaGcNYkjpv21+OAmXWUDSQvyElmzMYiL58cc8gR5zBEJ+hpHjxddoOGH1pJebWcCz2fHV/bcST6Sb2lTRqdrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF7811515;
	Wed, 21 May 2025 04:09:54 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 868473F6A8;
	Wed, 21 May 2025 04:10:06 -0700 (PDT)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: andrea.porta@suse.com,
	catalin.marinas@arm.com,
	jpoimboe@kernel.org,
	leitao@debian.org,
	linux-toolchains@vger.kernel.org,
	live-patching@vger.kernel.org,
	mark.rutland@arm.com,
	mbenes@suse.cz,
	pmladek@suse.com,
	song@kernel.org,
	will@kernel.org
Subject: [PATCH 0/2] arm64: stacktrace: Enable reliable stacktrace
Date: Wed, 21 May 2025 12:09:58 +0100
Message-Id: <20250521111000.2237470-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These patches enable (basic) reliable stacktracing for arm64,
terminating at exception boundaries as we do not yet have data necessary
to determine whether or not the LR is live.

The key changes are in patch 2, which is derived from Song Liu's earlier
patch:

  https://lore.kernel.org/all/20250320171559.3423224-2-song@kernel.org/

... with cleanups folded in, as discussed earlier:

  https://lore.kernel.org/all/aCs08i3u9C9MWy4M@J2N7QTR9R3/
  https://lore.kernel.org/all/CAPhsuW4UVkXdShpo2TvisPhr6S1jFPkS_BKXAjN9cT3=k5SAFg@mail.gmail.com/
  https://lore.kernel.org/all/20250520142845.GA18846@willie-the-truck/

... and due to those changes I've dropped prior Reviewed-by and
Tested-by tags, but kept everyone Cc'd.

Actual support for livepatching will have to come as as a follow-up, as
that requires additional support that Dylan Hatch is working on:

  https://lore.kernel.org/all/CADBMgpzPyW+EnB3A1Hr=LQGhuen4pUuJ0QYa44nH0qfQ9TFaSQ@mail.gmail.com/

Mark.

Mark Rutland (1):
  arm64: stacktrace: Check kretprobe_find_ret_addr() return value

Song Liu (1):
  arm64: stacktrace: Implement arch_stack_walk_reliable()

 arch/arm64/Kconfig             |  2 +-
 arch/arm64/kernel/stacktrace.c | 55 +++++++++++++++++++++++++++-------
 2 files changed, 46 insertions(+), 11 deletions(-)

-- 
2.30.2


