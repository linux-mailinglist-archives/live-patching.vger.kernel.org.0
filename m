Return-Path: <live-patching+bounces-2151-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6DlUL1X9qmkIZQEAu9opvQ
	(envelope-from <live-patching+bounces-2151-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 17:14:13 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AB3D224A31
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 17:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6EC8130BBEA8
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2026 16:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BDC36C0B2;
	Fri,  6 Mar 2026 16:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5/i+Yro"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862C83115AF
	for <live-patching@vger.kernel.org>; Fri,  6 Mar 2026 16:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772813367; cv=none; b=u0CKxsT1iMlvx46rjDeHbWu/O9ljkZmn78hwIc8NIjDOzFHkijPEK1tzmNrq/8VQMWxcnR4+mA8dFCTT2tmyR+7fYC/kaTOINGAiecd44pqJEFCm08EenkwJLu9E0qGw/AJLzl7012tMK3602KB/ZuDakz6sAvjFOwba/IXXqu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772813367; c=relaxed/simple;
	bh=jkJMgauDX1t19dAN3PhNCeHQj3PQivjP8ilh4ArcwfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PC824O650Clq76Sb9s5szDEQSLeup4RS+D00wpc6IaEl5or5K90Z4gT+c324SRToURtOcubXrSGlLMsHMOaiaS6iifMnWiPIh2PH5dfJIz4MlI5ME9zYe/UuCAVlTLHkGF1QN6jOeDAua99Ixv46hvPemBOoQqsHPB8MKFasC9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5/i+Yro; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F417CC4CEF7;
	Fri,  6 Mar 2026 16:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772813367;
	bh=jkJMgauDX1t19dAN3PhNCeHQj3PQivjP8ilh4ArcwfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z5/i+YrotTWDUZo4o2gHMgDzg28xIvoKCXP8F4eIlDOjU3Jajm2vnlC9G+xlD2XRt
	 RhvLonJvIfZjsz1Ekwlnxc0MgLY/jT5PhduK5aheSyEmcto7k+RDJ1BhaCJymp/h5P
	 cVf9qCN2KK2rDH15Eydxko2cghQ7p0A3ajLGqVlVV480wPk0+j9htsxG0ANceRoOJH
	 B6sMkTcM6inY7+xMIt89bDph53bTrc1uLr/cAKmkAUrrMJEV3PIGlnvbTz0xzcBZQR
	 mR3KYbPmTRZykhmBuEPjhXCf5CNM6m8FGWkuoUSxZsqy8VI4x5vFFZgNtgVOE4256b
	 i9pzVNCKFfAEA==
Date: Fri, 6 Mar 2026 08:09:25 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH v4 0/7] objtool/klp: klp-build LTO support
Message-ID: <kgfsbith6oibrvgytcnncg2zyrxfa6wc3ltpqulyrk2633oetp@wrkqqifhesxn>
References: <20260305231531.3847295-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260305231531.3847295-1-song@kernel.org>
X-Rspamd-Queue-Id: 5AB3D224A31
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2151-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.941];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026 at 03:15:24PM -0800, Song Liu wrote:
> Add support for LTO in klp-build toolchain. The key changes are to the
> symbol correlation logic.Basically, we want to:
> 
> 1. Match symbols with differerent .llvm.<hash> suffixes, e.g., foo.llvm.123
>    to foo.llvm.456.
> 2. Match local symbols with promoted global symbols, e.g., local foo
>    with global foo.llvm.123.
> 
> 1/7 and 2/7 are small cleanup/fix for existing code.
> 3/7 through 7/7 contains the core logic changes to correlate_symbols().
> 
> Changes v3 => v4:
> 1. Minor fixes in patches 1, 3, 7.
> 2. Only keep patches 1-7 for now, as there is ongoing discussion about the
>    test infrastructure.
> 
> Changes v2 => v3:
> 1. Fix a bug in global => local correlations (patch 7/8).
> 2. Remove a WARN().
> 3. Some empty line changes.
> 
> Changes v1 => v2:
> 1. Error out on ambiguous .llvm.<hash>
> 
> Song Liu (7):
>   objtool/klp: Remove redundant strcmp() in correlate_symbols()
>   objtool/klp: Remove trailing '_' in demangle_name()
>   objtool/klp: Use sym->demangled_name for symbol_name hash
>   objtool/klp: Also demangle global objects
>   objtool/klp: Remove .llvm suffix in demangle_name()
>   objtool/klp: Match symbols based on demangled_name for global
>     variables
>   objtool/klp: Correlate locals to globals
> 
>  tools/objtool/elf.c                 | 95 ++++++++++++++++++++++-------
>  tools/objtool/include/objtool/elf.h |  3 +
>  tools/objtool/klp-diff.c            | 89 ++++++++++++++++++++++++++-
>  3 files changed, 165 insertions(+), 22 deletions(-)

Thanks!  I will go ahead and queue these up.

-- 
Josh

