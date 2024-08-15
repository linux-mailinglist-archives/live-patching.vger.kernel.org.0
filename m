Return-Path: <live-patching+bounces-502-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2927495384C
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 18:34:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 598901C20AB5
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 16:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DCEF1B4C2D;
	Thu, 15 Aug 2024 16:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlETQkih"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F81017C9BD;
	Thu, 15 Aug 2024 16:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723739662; cv=none; b=mu6j5k+f30Q6raIEtJ3eFND90PjO7hp5mRSH2pgrWUhWnCAw9dR7zsBeYYqwqAT2COAnVQXWP7c9zZrI6xVN/Hl5YPOwnmD7JYpjynuwmXoxvEICJYcLOejdociQ82TbqPmzcdmUfcF/SyDAom5GR+08J7abDcsRy2l3MDaRVLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723739662; c=relaxed/simple;
	bh=CIGtFWY5zAeXbqUb7p8Agsr5ZBAMfp2fyVDmFi6wsVo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y640LC03L71z3/MflMRaZfSyy+yuE5kOG3fMv3UPMmZecUgY7KYNz/4CMQWXT/VExVNKJPvzNmnWEiWSDGzJ34dR3Ol7WlHRVQyGY0hHzlFOtv5unNnRhXBBBzguG7g4S3GPmrLoLYWy4jpsBbYeR6/R7niXSFd8EPBx/kpFc8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlETQkih; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4183C32786;
	Thu, 15 Aug 2024 16:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723739661;
	bh=CIGtFWY5zAeXbqUb7p8Agsr5ZBAMfp2fyVDmFi6wsVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlETQkihirHcqixNy9FXfGsH3ilM4Ls+BCGWImVhZ0VwySUbaQBOjl7b1Zpp4Irg6
	 2h0PSrxhENxhaNSCsrhvM5Dm34jxHVJR6a+gd2O7RxjrgfIYdkFR8aIGeVoj20Ide1
	 0bbqPXaw6+F5RT6S95w7MR2k/kiKXSdrnBsK1TXXBmYI4BRxepo6T21//glOEXo2PA
	 O1+yOZ1DpIo/gzs60jTvAFVImujmA00yCATOHzq+LN4JW+QgmA/dMSkfuAwWCmkDcr
	 adqrZW4lUapvhFnEn3jK0A3xH5TWU2ZWHQuTI5SWtcDcrWU0//itgd0XeiU21Twyoj
	 la4P9HfUVEavg==
From: Kees Cook <kees@kernel.org>
To: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Song Liu <song@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	nathan@kernel.org,
	morbo@google.com,
	justinstitt@google.com,
	mcgrof@kernel.org,
	thunder.leizhen@huawei.com,
	kernel-team@meta.com,
	mmaurer@google.com,
	samitolvanen@google.com,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: Re: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
Date: Thu, 15 Aug 2024 09:34:17 -0700
Message-Id: <172373965417.621926.8551687004756195926.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240807220513.3100483-1-song@kernel.org>
References: <20240807220513.3100483-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 07 Aug 2024 15:05:11 -0700, Song Liu wrote:
> With CONFIG_LTO_CLANG, the compiler/linker adds .llvm.<hash> suffix to
> local symbols to avoid duplications. Existing scripts/kallsyms sorts
> symbols without .llvm.<hash> suffix. However, this causes quite some
> issues later on. Some users of kallsyms, such as livepatch, have to match
> symbols exactly.
> 
> Address this by sorting full symbols at build time, and let kallsyms
> lookup APIs to match the symbols exactly.
> 
> [...]

Applied to for-linus/hardening, thanks!

[1/2] kallsyms: Do not cleanup .llvm.<hash> suffix before sorting symbols
      https://git.kernel.org/kees/c/020925ce9299
[2/2] kallsyms: Match symbols exactly with CONFIG_LTO_CLANG
      https://git.kernel.org/kees/c/fb6a421fb615

Take care,

-- 
Kees Cook


