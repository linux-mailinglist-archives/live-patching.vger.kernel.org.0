Return-Path: <live-patching+bounces-14-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D23D7DF183
	for <lists+live-patching@lfdr.de>; Thu,  2 Nov 2023 12:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2864B210B7
	for <lists+live-patching@lfdr.de>; Thu,  2 Nov 2023 11:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 247BF14ABF;
	Thu,  2 Nov 2023 11:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kdTgOF/W"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4C314AB3
	for <live-patching@vger.kernel.org>; Thu,  2 Nov 2023 11:44:22 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7213A18C;
	Thu,  2 Nov 2023 04:44:13 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 1F1F11F45F;
	Thu,  2 Nov 2023 11:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698925452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=0wTQJfteT+mAnLUIdZiNccKp2ftr1wjjD1lVugRYtcY=;
	b=kdTgOF/WQTRSU95ACb/GB9tQmEtCSpw384tm7CZGSAC9mQTdZzk2KxdL+k+DMybv6HIxFH
	R9OwuhzcPfflrbu1PY6WwOtZjmStcXiWgtbxE6Pkf3Ayngs72IrYp1l7vSkTwWXAoeGFK3
	4hbdmTYVN9OW/41dSFvRsAzepkKDAlI=
Received: from suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id B4DBA2D351;
	Thu,  2 Nov 2023 11:44:11 +0000 (UTC)
Date: Thu, 2 Nov 2023 12:44:10 +0100
From: Petr Mladek <pmladek@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 6.7
Message-ID: <ZUOLil38w_VHEdvD@alley>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)

Hi Linus,

please pull a fix for livepatching from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.7

=======================================

- Add missing newline character to avoid waiting for a continuous message.

----------------------------------------------------------------
Zheng Yejian (1):
      livepatch: Fix missing newline character in klp_resolve_symbols()

 kernel/livepatch/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

