Return-Path: <live-patching+bounces-582-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0C0B96B1EB
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 08:37:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F35A91C257D4
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 06:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D78C613D8A3;
	Wed,  4 Sep 2024 06:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="feeruUSH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62C613A26B;
	Wed,  4 Sep 2024 06:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725431861; cv=none; b=P9Mdcfx+qutivEzN2o6dRyMnxC345gCSH186ieaBvPgpfyv3je8yGmfL0p5LDJLYszxpKVcsF7+9KRDV/FcACZZS4vsOwhQgmqc9VxpQKj9DLRLCEEAQNWD2APahbVYanaDEMbKmigZ1N63G90KTvr7vHdOYts8xl+GI7EIuDQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725431861; c=relaxed/simple;
	bh=B7Tw+Vgjv63Qyqa3vbVNmvqIAdsqmH0lE/Q2ozPDSgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hdJHeeOjo+uf2fugUEasvXK+ZGlevoDeEWn9qbIKHQdtfLxN+NmYvIfWsgDfVZnJIbIP8iNg6Mn5YVv7cMRFkLszTMXyBjJwkXFu7PgAjOMaK6RD+byk6ofXqQHFG01tzFIT594eqash4qpmyZaTrcTGS7pBX9n82gZ3W+3N5tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=feeruUSH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99151C4CEC2;
	Wed,  4 Sep 2024 06:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725431859;
	bh=B7Tw+Vgjv63Qyqa3vbVNmvqIAdsqmH0lE/Q2ozPDSgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=feeruUSH43RagVAlNStKKwvWj97G5J3D8NqfoEoNz4lhJJAF3H/jQm1qDMx69tPGf
	 0+3DxTLln5wqOS2na2nqRV1S5f3youoEhFLGrLdgxDi1EWcG0ImLAKsROGOJKAiAZJ
	 kz4PB8C6Lx4EedzD8NrNDDdxLictt3kro8aAPWEflobtbPIZrytn2up+/kxoVMs+bK
	 8eXTJgA4+qKQRmqDtE01iyR8yIUokmMTIvT/Dgr09Opapl2JTA4qq06h9rEnGfJn9j
	 GTM4KG6HWUOCP1VFCEqYdj5xVGrN1VDef7r680MTCp3PnhOaBco9xPXRJRbomD2Ka4
	 uXx9grbpV+UgQ==
Date: Tue, 3 Sep 2024 23:37:36 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <20240904063736.c7ru2k5o7x35o2vy@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
 <20240904043034.jwy4v2y4wkinjqe4@treble>
 <CAPhsuW6+6S5qBGEvFfVh7M-_-FntL=Rk=OqZzvQjpZ6MyDhNuA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW6+6S5qBGEvFfVh7M-_-FntL=Rk=OqZzvQjpZ6MyDhNuA@mail.gmail.com>

On Tue, Sep 03, 2024 at 10:26:02PM -0700, Song Liu wrote:
> Hi Josh,
> 
> I have attached the config I used for LLVM and gcc.

!IBT is triggering the ORC bug.  This should fix it:

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 518c70b8db50..643bfba65d48 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -60,7 +60,8 @@ vmlinux_link()
 	# skip output file argument
 	shift
 
-	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT; then
+	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT ||
+	   is_enabled CONFIG_LIVEPATCH; then
 		# Use vmlinux.o instead of performing the slow LTO link again.
 		objs=vmlinux.o
 		libs=

