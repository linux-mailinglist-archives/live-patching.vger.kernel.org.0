Return-Path: <live-patching+bounces-2477-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GCPGEiba6WnolgIAu9opvQ
	(envelope-from <live-patching+bounces-2477-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 10:36:54 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 73D9C44E9CF
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 10:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1FE130B4704
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 08:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6033CB2DC;
	Thu, 23 Apr 2026 08:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iZerBmu7"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFDB1B142D;
	Thu, 23 Apr 2026 08:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776933156; cv=none; b=WJa7FooaZ/lidnNesEDe14Q0k9wDxlArr+fAuAdgts8OVSv2Rww1bYiZQcbcryR39eF8iDvPI2gYlrPO1/LTI5g06zwiUH/ZSWB2xuAG5OE5cuiJKNzk8vfGMQXZtNx/WIOX9v8W3pkuaXSb4MCmWOtfiPH9hLqlvJyfFl/LnKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776933156; c=relaxed/simple;
	bh=uK00LG0iDpIMEjBQXm4byZgGPeE/DGU+c8Xl9e9qUVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIReglL4wwgBb7btA5qoRMsbf1mwRUYBFBOj2ApaKLu6OkctBdgsYhY0TBGsucoC+cI5OW/13bdCs0PNmnxdyzy9tWROUdwBbXLWAcOGVSTlRBHxUy2dGaz+Bcu2NZ7vd40LAa7oOXtb6EME0hy4zxxH0F0Hb5bc1TFLzNWcJq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iZerBmu7; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=e/PUtRuyjXu+9h0XjZ2apQLxXIpOKsrznUMF9nTbE0Q=; b=iZerBmu7+PJ8hgxjahYqrbbN/F
	82eyxOs2+bSHdpkOXRlY6+ku07UjA4L09k68N/4SkkCNarkHfums1689CoctrB9dudHycBpNkWs+k
	m9MlOyiRJX6xc2q/ewgi+9mBgbCIa+hHzpGz9jrxwoBVHdPzki/k2suc4HTKn4YLnq48Na0R6Zl61
	jS/SUa5jh+MRrGIfqfoCSihSO/OXEEg9GRzJNCc2441bG1lDDui4WUVdwR280Lx6IaZCfcv9+90ls
	qL3d4OP9B6VdTvCiiICVtK8M7etryQycRjwWzWauN28of8C9hOrOkq7IKpmbGPG5R3JkUDCz+zI/H
	b3McTseA==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFpU7-0000000D7N9-3bJn;
	Thu, 23 Apr 2026 08:32:31 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2E2773008E2; Thu, 23 Apr 2026 10:32:31 +0200 (CEST)
Date: Thu, 23 Apr 2026 10:32:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 17/48] objtool: Fix reloc hash collision in
 find_reloc_by_dest_range()
Message-ID: <20260423083231.GS3126523@noisy.programming.kicks-ass.net>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <09dab1995c4ba6ca29dd70b0a7472f1a2975fefd.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09dab1995c4ba6ca29dd70b0a7472f1a2975fefd.1776916871.git.jpoimboe@kernel.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2477-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,infradead.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,noisy.programming.kicks-ass.net:mid]
X-Rspamd-Queue-Id: 73D9C44E9CF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 22, 2026 at 09:03:45PM -0700, Josh Poimboeuf wrote:
> In find_reloc_by_dest_range(), hash collisions can cause a high-offset
> relocation to appear when probing a low-offset hash bucket.
> 
> Only return early when the best match found so far genuinely belongs to
> the current bucket (its offset is within the bucket's stride range).
> Otherwise, continue scanning later buckets which may contain
> lower-offset matches.

Maybe mention (and or add a comment to the function) that in case of
multiple matches in the given range, it will return the lowest address
one.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> Fixes: 74b873e49d92 ("objtool: Optimize find_rela_by_dest_range()")
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  tools/objtool/elf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> index a5486e172e5c..c4cb371e72b2 100644
> --- a/tools/objtool/elf.c
> +++ b/tools/objtool/elf.c
> @@ -370,11 +370,11 @@ struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *se
>  					r = reloc;
>  			}
>  		}
> -		if (r)
> +		if (r && (reloc_offset(r) & OFFSET_STRIDE_MASK) == o)
>  			return r;
>  	}
>  
> -	return NULL;
> +	return r;
>  }
>  
>  struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset)
> -- 
> 2.53.0
> 

