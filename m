Return-Path: <live-patching+bounces-1422-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FEF7AB1F1B
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 23:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D11D64E8773
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 21:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99C423F413;
	Fri,  9 May 2025 21:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="acxN55X/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEFE231A21;
	Fri,  9 May 2025 21:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746826627; cv=none; b=rjShOpLVxB3ZyUzxs5w1FQVGLrkqJCMctwYL5Vn3paS6TlbPEwJinJh5mtBGR2WDkFzKli7MH/tQFsHYJNTAqDCWqNqenlM+enyymdi7VVxw9PqFn0QnROA+tVFWrXvY9/XAlvyG40NCr7HsaiLoM6KO0v8EWKJm7vvQljWRpts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746826627; c=relaxed/simple;
	bh=Pk19fn8HgewsfAPMOxuaW+DBv3DoTvro8u9F+0m0XpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0srPZL3L01eTewGSXTQPZVw0rbOMlbrA78qxbElj7Er6F6ZpSWDT8hCH2QkBxUgD1LZawjBnPF4ARCLthPHL6OgJJC271sGvH1SnG2NNqX93oEt7V0uJ1TvyVsfra9REpaEeMrRno2u89R87lSetyX35bqM3y2W8WW1JiiRqj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=acxN55X/; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E52F140E023E;
	Fri,  9 May 2025 21:37:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 662FpYmUc_7L; Fri,  9 May 2025 21:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1746826617; bh=iaGMkFbQ4D/7qDFb5MMv0dLPYiVkli9ypk8n31O87eM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=acxN55X/AK1vJ+bf//5xYZyTOBb/sU3XjeSZX+N3dZpc4iyv3B/Vln3NfPCx76Ke8
	 iEcadd5xLnOqPvvK5SbURqOJDfnomfxt+706k62TbxVbVZnv98AHwi4Tsmi1+OjPVM
	 0jxveFKKdn5QIv+7Ej2ZUi01LLyToggOf1rEgbb14gq5tNlJJAYvXjyFaVis9IDWuL
	 pf+4VDp54rxXomNp8zeYEo/w6MfttlspidxyrdmSGI+9L/ctr5uNbvP8a9cwaNo9TQ
	 3chcs+T12iq5ZkCrUyGqMdrLUECo16tX3tnuJ+CPk9RaopkQ+44tTS5tKVe85o7bHQ
	 vgv59frrT8PA8imvAsNs7Gl6MHtmd7vpP3gsRm1j646gxMSdmwIgZYzavTm/R0+Awq
	 oQyj1WbyS8BlbfHNEx4W0S+EE7UF8QydmQZjuRSQyUBGB7eyENUIdum3oIQJy4jW27
	 Aip5/r6cJcUPmOnLdFN3/SVk1hq7vCrNhjAV0yHCpUQunqq5zBQNZZ/h64LhUlGTpJ
	 F2r+mT+Cls4+ztUBtPDxgDHk18sK5l2VwaCrUxo+X5Dwx2cUBubUJztY2bh+SKZK5S
	 GyXEx+ON/gzposdGL2JxNPWBvPKgk5+Ss83bL5SLxms0qCs7VI48sK5lGRBhQ5WoMk
	 s2G0z60cJryonRQBwXPvDbUA=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9AC8F40E0239;
	Fri,  9 May 2025 21:36:42 +0000 (UTC)
Date: Fri, 9 May 2025 23:36:35 +0200
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
Message-ID: <20250509213635.GFaB51YzAbFIlC37QS@fat_crate.local>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <68a8126c21f4ee054d6c4d6262d0f465b5babd89.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <68a8126c21f4ee054d6c4d6262d0f465b5babd89.1746821544.git.jpoimboe@kernel.org>

On Fri, May 09, 2025 at 01:17:07PM -0700, Josh Poimboeuf wrote:
> +#define ALTINSTR_SIZE		14

We have sizeof(struct alt_instr) to offer...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

