Return-Path: <live-patching+bounces-1844-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4F1C54D65
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 00:49:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5AD7C4E1BBF
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 23:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2590D2609CC;
	Wed, 12 Nov 2025 23:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qo+zwIZi"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2221C2BD;
	Wed, 12 Nov 2025 23:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762991279; cv=none; b=Xhn5/27e6gHSNJOe44tbbLtHZvXL5fWGNzSa63DFs4cW//6iz0/VnivVIGmIq8JOixP5OpSnLqyM84KcfpdRxxCus/wioLLdWevwdTNsGdm0br75V3PfwEmCv5whkd9v6EQaaugzKQKQYY6obVuDGn5w+2xtUDMrMnupdn4fn4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762991279; c=relaxed/simple;
	bh=kK6d1gDCSEsQb2d2y6y3ycUWObNrgwIqKz569KQlvg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FSpXX9E7zP6O+wNN9v5nYHEy7jqNLj3ZraJZqfs/ebRGWfh99v6RuMHcricXK4WEq+hGeoCpJN98MhyfYI7YBecpv+ibKkUzGw+/l/iEG4+JS8RSGBhUI/nYPgVeJHB06kSFCkpKGvLrBLBkA71HW7BDkedB5paXguYtdGtTkzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qo+zwIZi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57635C16AAE;
	Wed, 12 Nov 2025 23:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762991278;
	bh=kK6d1gDCSEsQb2d2y6y3ycUWObNrgwIqKz569KQlvg0=;
	h=From:To:Cc:Subject:Date:From;
	b=Qo+zwIZiS5qPVToEUYfpc+h7cHXlY59V6fFNFx+QYbSd+JrK2LcgacZZTpNt4aS/g
	 sJpDjnx4ObkZYgqHdUoxcYMTYJMfNV0+vcohHuvtDk7dC4vV/BhnqbAd31krlrFAhb
	 MV7MBomXohnsoJwdmIUkF48vYQmZqeJxwVZkHM1BErpSC5/ra/qxxIpYTdDTrdQvDV
	 /CP5UAR33auWYvSu1X20p5YeJEEVav3HULCt0tty1/DYIzj/Puy425z4n1925b3Cup
	 0niAhAYpq20YyxR/ASGUmlVWn/5OXffqRX2DTsPc342Ptkx8R6cQURNvYu8LYGazgm
	 VKzqYE+CVFrtA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org
Subject: [PATCH 0/4] objtool: Fix some -ffunction-sections edge cases
Date: Wed, 12 Nov 2025 15:47:47 -0800
Message-ID: <cover.1762991150.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix some more fallout from commit 1ba9f8979426 ("vmlinux.lds: Unify
TEXT_MAIN, DATA_MAIN, and related macros").

For tip/objtool/core.

Josh Poimboeuf (4):
  vmlinux.lds: Fix TEXT_MAIN to include .text.start and friends
  media: atomisp: Fix startup() section placement with
    -ffunction-sections
  drivers/xen/xenbus: Fix split() section placement with AutoFDO
  objtool: Warn on functions with ambiguous -ffunction-sections section
    names

 .../media/atomisp/i2c/atomisp-ov2722.c        |  6 +--
 drivers/xen/xenbus/xenbus_xs.c                |  4 +-
 include/asm-generic/vmlinux.lds.h             | 38 +++++++++++++------
 tools/objtool/Documentation/objtool.txt       |  7 ++++
 tools/objtool/check.c                         | 33 ++++++++++++++++
 5 files changed, 72 insertions(+), 16 deletions(-)

-- 
2.51.1


