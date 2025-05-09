Return-Path: <live-patching+bounces-1424-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 185F9AB1FB6
	for <lists+live-patching@lfdr.de>; Sat, 10 May 2025 00:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A14257A674D
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 879E8261565;
	Fri,  9 May 2025 22:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="LqTS3gBw"
X-Original-To: live-patching@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CD7261399;
	Fri,  9 May 2025 22:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746828794; cv=none; b=kcIOq6ME8jtzyXD9NdlY/GEPYUXRQ1umFnYDzU4sc2xdnOPbVdXzqmPmQdCRQ5HLxxnRmhkx4kk0EOwEHjsH4mJVmtg0DqqrmpJFmM2fST2tkxRyC4WlJ0ECVaDbCmXbEOnkNfCZXDC9Ard7Hl7W38/MvKIklV+cwlsTowN+h+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746828794; c=relaxed/simple;
	bh=BfrFfELWW3+UrgSOiH4UXZ9Ta4VUjbwmJzYcDJxUpW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K4IjeoRHWkVUPiSHaTSeKbQKFSgqyc/CF14nfPXlSD47pmzA1LPGOrE1ZZTkX8xEQcF/qXXVg4IFCwQeXtx3TMN9hmXKsMw0Srn7aPkWk8LaoHbmxhje/NTrd5f+EFoEf7xKNQUSn/Y0KWe4y2neBarXrg5773qcmOUxKbVMuUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=LqTS3gBw; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E7B4240E023E;
	Fri,  9 May 2025 22:13:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jgYeXQKVFDsw; Fri,  9 May 2025 22:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1746828778; bh=Z3K2BVjA7j2LUuahJEX1B3DgJ/pI+yotAmrKie8D/lE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LqTS3gBwF3ftaNl/LiXXmbo7ugHXLoP9V77GE6e6cI0//ogoIgmZgs1wr0UYKwTDe
	 0Pp/iXrbZu+UMcTjV0URPAnRme8uxjF9Csf8XbovENRBSAx18Y2xlDffKcpOcD3n1f
	 H1wTwGRALZDgXPSGi9Yel7i/Z0gHLjxxXAp/it//wA1DsFMx/GsSdThp4VtDbpyXY0
	 H10Eaoc1exWPxVLaNgVj4vrHC4agj6PvO0ne8C5FU/DOxBkHasQPwO39mXNQ2d3zrv
	 vhv/W4Coqc3dAmX+T1fH4eyAgtC2h2m4Q5HBbDVa7cNTgdCfbwE3bjaqJ9bSaMrk++
	 kLr+May4NJ48gRZQyKgP4ll/UbzrH70y5XKVZfXSgFfJb2WhipqJ35E8ZwFsmfUEPu
	 TrtJ2cRqX9mYK/cQNHzpvsh7F/ElSlR79garces/Y5Ej7rQdvR2atx1PFVeGIOD043
	 K3klKl7wD9lU/KF6MyY4wDhj4YTB8zCK+5sN2QivUwZ4M2AgVj9oFl71zBz0O2dDCg
	 kdZYSAHSlydgDtKynjW/0coUuu98y3QJcvSmgUEianVmLAwQS9vaNzvlieVVC2ovkW
	 jmQeNMah4xDdKXwLcFGiCi/9cckxaREkN8dU1V4vTvv8OUr9QC3urAkG8ByqefjE2d
	 upUCsFdlR5+g6pw4tyVRUlq0=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 625F940E0238;
	Fri,  9 May 2025 22:12:43 +0000 (UTC)
Date: Sat, 10 May 2025 00:12:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 43/62] x86/alternative: Define ELF section entry size
 for alternatives
Message-ID: <20250509221236.GGaB591CVcWMLiMJN5@fat_crate.local>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <68a8126c21f4ee054d6c4d6262d0f465b5babd89.1746821544.git.jpoimboe@kernel.org>
 <20250509213635.GFaB51YzAbFIlC37QS@fat_crate.local>
 <tv2gorcohozg6ppwetgi5qqgoabsrv62qbgsgph6z7zk6vxln2@qmgsjufyenjh>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tv2gorcohozg6ppwetgi5qqgoabsrv62qbgsgph6z7zk6vxln2@qmgsjufyenjh>

On Fri, May 09, 2025 at 02:54:00PM -0700, Josh Poimboeuf wrote:
> On Fri, May 09, 2025 at 11:36:35PM +0200, Borislav Petkov wrote:
> > On Fri, May 09, 2025 at 01:17:07PM -0700, Josh Poimboeuf wrote:
> > > +#define ALTINSTR_SIZE		14
> > 
> > We have sizeof(struct alt_instr) to offer...
> 
> Right, but IIRC, sizeof(struct alt_instr) isn't available at macro
> expansion time so it would have to be provided as an input constraint.
> 
> That doesn't really work for the ALTERNATIVE macro, where the asm
> constraints are out of our control because they're set by the caller.

Bah, that doesn't work. And you're enforcing it with BUILD_BUG_ON(). Oh well,
ignore the noise.

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

