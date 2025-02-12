Return-Path: <live-patching+bounces-1156-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C96A32648
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 13:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6ACDD7A34FB
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 12:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FD11E87B;
	Wed, 12 Feb 2025 12:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KvP9Lsmk"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C97209696
	for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 12:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739364687; cv=none; b=TH0whJmsFZD8zdFzUxVleBuvwKx4sbkAeoWvYE8hEcJAfNiL0a5xuMlIwgtPedEIq24mG9sBrI6TMIS8hkEd4AGYr/6a8qAT97YbROxNYsGdMbkhC8ir0xWQpp+qC04SphVuWWl7McuQ+yMa6k0PitCTPh8WIujBoMAIVyPGTZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739364687; c=relaxed/simple;
	bh=SqERsuHGMfmKYwvGULxgOstvraiFdPgWZw+Mz4Mf2Xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BKMs890S41+cPwNaXcQPKLYXnVQVF4EjAbOymnAYvG24/MqenGlZGMCs0ldhUW/9PYqddUVwN/zd6JHDsTLqpr+PDWRLm+bYq+RoINFyEA9slp8Egg8uoFQz5ThGJpDDYrJNDD917tUI1vppHX+G2PEm9aYzaUS6b4cf3HvKDYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KvP9Lsmk; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ab7f42ee3ecso143415366b.0
        for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 04:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739364683; x=1739969483; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DVRCRSLVIRhRauydzBbKCkxxzLsY6TcE3GpHdPvtjuc=;
        b=KvP9Lsmk+YazLehWygbLRfevDEP2+ptwOAk0ADWuEvZI6CdGnBs9OcF9lGVQjEsJHW
         UmEE4xOUKS1qSmMO5Aj48/yCu9Y80uFN/JvKWjd3im2DE0Urp3Jaz7w30BAZl0Wo6lq+
         pcbJVjNlY44o0X9EpZQdwCb6LrP2TU7842WcCjaArRMQgKTP2s464vJctEygLMRyPQoB
         5zgYFGyqdo14AQm9yhfseS6syLfdRzE9SCxt5hNuRwOfN0nkFCWavxrxqeMqfYj4510W
         yDlN7FhnaEcGezD0nRVBiBMHPgFpHZ939alECUG+DCDY4L+1G0dcFN3+tqlsnzH9+4dE
         xkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739364683; x=1739969483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DVRCRSLVIRhRauydzBbKCkxxzLsY6TcE3GpHdPvtjuc=;
        b=u883QXcRemv+YGkl/Tnyz3x9ZmsT1bHWuEyb3oSjYjAZukNHG36fGcISW6CoyU3XcV
         PRJDbm93Q2Wk4lXNx2VjJP+FCtk8K+CocfxPCGCNuNKu+NmUdL4nrDATZIHWI7vjgZv2
         d4wtPYWWPCOUQie9kO+bRLXlUVCfD2LLe2R9TtZpukDjrMeAWCvHHFv2qnVgwNnMPVI1
         pzERVAVgoljXAFsrnpZ9r/1DC/mdVFb+gNAuOWPYBHydcKLimvK+n9U8ylxUDQY2TE9r
         Es/x+Kj4KPSymygqdWW2TXDIcD/9CKdPAKEi040NppAnNehPTbMMZgkSEs664YxqPQmA
         /ofQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDRNE+Nn1ocNjHZvdIygFsNaLt0dtghRoPAaoYgyv1ZJosdThDn8IEaF3ooFHgb5C3OMrC7Y2mLGbhOUd+@vger.kernel.org
X-Gm-Message-State: AOJu0YzSEZCb8miYNE6fqBN1eyVVfEvHPPj0s1+QO/ZEICL4+hEDT4w8
	wVnWGYe7msV8V092p+eHIS9EqxZxOI5jQhTiXroCz7yRQXaVOHFP1tD8eu6YUMQ=
X-Gm-Gg: ASbGnctTzpTGmCI/yC4QI4ZptYAn4jHxDK73TjcLqhRk75gnYfxt4yl7zCNwFpsrqdh
	5ZlKe0+Mgoove0MNbCPsDAJjLQ0zkWWzcFrcFYbZtFfldZWkoG+2ExygjndLr8dkN7oud57xo6W
	ZobXwLf0ccUt19q/zwQuGwpMFxhlsLpkGK0xIIj5ILRwjC3ZFLGXOliGX8szEl/nkCrDrdJznVZ
	aABNF+SNHbOy7U9dG0qcygRCYOgIguqMhc6ZSs36qZXh+4M48ZPVfc2YzNMzRI/Zhnd+w3OFR8/
	3hCqf2T5R2t+0n5FZg==
X-Google-Smtp-Source: AGHT+IEIHqJGTYT1i5b2b84deTMi3zZ6rZxGbUQzNXpdLm0jwXlKaUtzJmMcK4lFDAo8TgdwBsg2vQ==
X-Received: by 2002:a17:907:2ce5:b0:ab7:63fa:e4a8 with SMTP id a640c23a62f3a-ab7f3196a7emr258568866b.0.1739364683587;
        Wed, 12 Feb 2025 04:51:23 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7c5dd464asm558230266b.185.2025.02.12.04.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 04:51:22 -0800 (PST)
Date: Wed, 12 Feb 2025 13:51:20 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH 1/3] livepatch: Add comment to clarify klp_add_nops()
Message-ID: <Z6yZSBxbLBktQaXP@pathway.suse.cz>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-2-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211062437.46811-2-laoar.shao@gmail.com>

On Tue 2025-02-11 14:24:35, Yafang Shao wrote:
> Add detailed comments to clarify the purpose of klp_add_nops() function.
> These comments are based on Petr's explanation[0].
> 
> Link: https://lore.kernel.org/all/Z6XUA7D0eU_YDMVp@pathway.suse.cz/ [0]
> Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Petr Mladek <pmladek@suse.com>
> ---
>  kernel/livepatch/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 0cd39954d5a1..5b2a52e7c2f6 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -604,6 +604,9 @@ static int klp_add_object_nops(struct klp_patch *patch,
>   * Add 'nop' functions which simply return to the caller to run
>   * the original function. The 'nop' functions are added to a
>   * patch to facilitate a 'replace' mode.
> + *
> + * The 'nop' entries are added only for functions which are currently
> + * livepatched but are no longer included in the new livepatch.
>   */

The new comment makes perfect sense. But I would re-shuffle the text a bit
to to make it more clear that it is used only in the 'replace' mode.
Something like:

/*
 * Add 'nop' functions which simply return to the caller to run the original
 * function.
 *
 * They are added only when the atomic replace mode is used and only for
 * functions which are currently livepatched but are no longer included
 * in the new livepatch.
 */


>  static int klp_add_nops(struct klp_patch *patch)
>  {

Best Regards,
Petr

