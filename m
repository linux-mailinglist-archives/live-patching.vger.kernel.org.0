Return-Path: <live-patching+bounces-1423-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C658AB1F73
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 23:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D317178FC4
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 21:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE6025FA10;
	Fri,  9 May 2025 21:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGuKlBbt"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44ECD221DB9;
	Fri,  9 May 2025 21:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746827643; cv=none; b=A0zYdChZWD5cOF1TrI6+bcjypa9p6TBtW72r1a0ear9Rch5L2NgPe4V4q489SarfaD8LNdlOzrPH2fbThsTgEvvi7W2HWPeEkE5RR3TRBUCkYDwdiUoGd4R/ZQ1b6UJHUV3p8hsr6uyhx1xJO9TTkUTbTjmmCLGZ7NvuOzFYPyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746827643; c=relaxed/simple;
	bh=pS6iwIc5hy8etWjwv3VDIKQz2brJG3aRcW2/vvmP5h4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mWs9b0XWYsWp9QiI7DpsSXjE3gsYM82y4x+N9PwDiXrhi7gTUbiSZ4O3U0us2QW+rX4AGVZTL0EbdS7OEaZtdj3NiBe1y1MQRfuJGLET/qq8+5hY+Y/mYAC7fnYl7SrG76N4DE8DDwkbSNOUFpTMuwpWzwJubJeTt4K0+/sFF38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGuKlBbt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFAAC4CEE4;
	Fri,  9 May 2025 21:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746827642;
	bh=pS6iwIc5hy8etWjwv3VDIKQz2brJG3aRcW2/vvmP5h4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KGuKlBbtyJqSPrEZ6EWhRTfRxsneDnR4wT5bO2TkD5D/aX6BDkuEL30CPVkkH1bwR
	 40dLozdyYQM77K/tV/62QlWf4xCbQU4xDoPUf7fWj0Un7abKfUDI6klumzEbU4O6cJ
	 PL8nCHPGrMp72bnDMqi3clwZhK+L7jxqEo68RoEEAKpq1B9IjbR8gdaFnehjP2hGLv
	 GjhpfXeQ3hJywxLmWvZaVO+iXDGORLrj4E2P9nzyO6vjkg6elyN2+Tuj3Lt0PudzL7
	 1OFizS3kdqzM/PTu1vEcU/I6DzmL21GzzRm5KeFixQEAc190i8A96b3Z6oHLjeQXbK
	 VJJRB1k6vebNA==
Date: Fri, 9 May 2025 14:54:00 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 43/62] x86/alternative: Define ELF section entry size
 for alternatives
Message-ID: <tv2gorcohozg6ppwetgi5qqgoabsrv62qbgsgph6z7zk6vxln2@qmgsjufyenjh>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <68a8126c21f4ee054d6c4d6262d0f465b5babd89.1746821544.git.jpoimboe@kernel.org>
 <20250509213635.GFaB51YzAbFIlC37QS@fat_crate.local>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250509213635.GFaB51YzAbFIlC37QS@fat_crate.local>

On Fri, May 09, 2025 at 11:36:35PM +0200, Borislav Petkov wrote:
> On Fri, May 09, 2025 at 01:17:07PM -0700, Josh Poimboeuf wrote:
> > +#define ALTINSTR_SIZE		14
> 
> We have sizeof(struct alt_instr) to offer...

Right, but IIRC, sizeof(struct alt_instr) isn't available at macro
expansion time so it would have to be provided as an input constraint.

That doesn't really work for the ALTERNATIVE macro, where the asm
constraints are out of our control because they're set by the caller.

-- 
Josh

