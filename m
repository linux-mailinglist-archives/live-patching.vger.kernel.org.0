Return-Path: <live-patching+bounces-2162-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aBSDIyj3r2mmdwIAu9opvQ
	(envelope-from <live-patching+bounces-2162-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 11:49:12 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EA18E249AAE
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 11:49:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9ED9830AE74B
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 10:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A7E371D03;
	Tue, 10 Mar 2026 10:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UWMiFP8R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eREMvylQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UWMiFP8R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eREMvylQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892B9333727
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 10:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773139664; cv=none; b=MMGBjhOKD1WJpj9g++GOrojWBQeYyJ/fJcge6kzAe1u98JD6vI0UzQp/NnFE0B5ra1VLhRm+Q8wF54c1ALNQPx3koRNopygU4hNvtVVFAS6CMxZe57S5haZySId5EKJHIdCzB/qCD/QXCRAdk/L02Yw28TbStWY/HI5zsG8bNEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773139664; c=relaxed/simple;
	bh=EAEGanuva4ND7WiKYcaYdQU2dEkxyWVEA1mpD9eT2u0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=J9Kcz+RtzFkA0XVMkLFoocv/opQ32NYPEqD9PwgcMHoB6OQt2A2Q2LJWJO6dx0K0nKzKt3GAroSWPj03cjgxbvHWgwQCPfPmdCDp3zmW1zzlV95y0pTNA6oUmebX56fi2KBB1hxneykPZEV1eDFgfOUfsrpswIJaecusqK9msuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UWMiFP8R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eREMvylQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UWMiFP8R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eREMvylQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E03F64D226;
	Tue, 10 Mar 2026 10:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773139661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fButc+f13SCo47DSHV1k0O12zbFQiKqnmSQCu0ZA38k=;
	b=UWMiFP8R5afxiY1vuQ2AfsUcr1WPgF1Qou1eEU9EFbNUTnNmjU2xhRK+FMvFyMFlUt2gnO
	0Vsn+JyfhVZAd6mrZmvgRDk+ek8xRs2p2fhPisf+BVvo3HyRqezCjqNtsmzzw8tVzUdtLI
	Ss+RstlXrcChXBYl5zApM8EBmauQiLU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773139661;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fButc+f13SCo47DSHV1k0O12zbFQiKqnmSQCu0ZA38k=;
	b=eREMvylQzHgu5Vml5fCzwFY1vZ48NcNsjK/H+7BJbObhdZ6fgGzi8bw0/x3+ZB3Pug1HQH
	9C4447sJyLFfQgBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773139661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fButc+f13SCo47DSHV1k0O12zbFQiKqnmSQCu0ZA38k=;
	b=UWMiFP8R5afxiY1vuQ2AfsUcr1WPgF1Qou1eEU9EFbNUTnNmjU2xhRK+FMvFyMFlUt2gnO
	0Vsn+JyfhVZAd6mrZmvgRDk+ek8xRs2p2fhPisf+BVvo3HyRqezCjqNtsmzzw8tVzUdtLI
	Ss+RstlXrcChXBYl5zApM8EBmauQiLU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773139661;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fButc+f13SCo47DSHV1k0O12zbFQiKqnmSQCu0ZA38k=;
	b=eREMvylQzHgu5Vml5fCzwFY1vZ48NcNsjK/H+7BJbObhdZ6fgGzi8bw0/x3+ZB3Pug1HQH
	9C4447sJyLFfQgBg==
Date: Tue, 10 Mar 2026 11:47:41 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
    live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
    Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
    Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
    Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 07/14] objtool: Extricate checksum calculation from
 validate_branch()
In-Reply-To: <7a1e22454a3fd1d968775c24aa0529a4ec7c5886.1772681234.git.jpoimboe@kernel.org>
Message-ID: <alpine.LSU.2.21.2603101144410.14672@pobox.suse.cz>
References: <cover.1772681234.git.jpoimboe@kernel.org> <7a1e22454a3fd1d968775c24aa0529a4ec7c5886.1772681234.git.jpoimboe@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Rspamd-Queue-Id: EA18E249AAE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2162-lists,live-patching=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Hi,

> @@ -3691,9 +3691,30 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
>  				 struct instruction *insn)
>  {
>  	struct reloc *reloc = insn_reloc(file, insn);
> +	struct alternative *alt;
>  	unsigned long offset;
>  	struct symbol *sym;
>  
> +	for (alt = insn->alts; alt; alt = alt->next) {
> +		struct alt_group *alt_group = alt->insn->alt_group;
> +
> +		checksum_update(func, insn, &alt->type, sizeof(alt->type));
> +
> +		if (alt_group && alt_group->orig_group) {
> +			struct instruction *alt_insn;
> +
> +			checksum_update(func, insn, &alt_group->feature, sizeof(alt_group->feature));
> +
> +			for (alt_insn = alt->insn; alt_insn; alt_insn = next_insn_same_sec(file, alt_insn)) {
> +				checksum_update_insn(file, func, alt_insn);
> +				if (alt_insn == alt_group->last_insn)
> +					break;
> +			}
> +		} else {
> +			checksum_update(func, insn, &alt->insn->offset, sizeof(alt->insn->offset));
> +		}
> +	}
> +

does this hunk belong to the patch? Unless I am missing something, it 
might be worth a separate one.

Miroslav

