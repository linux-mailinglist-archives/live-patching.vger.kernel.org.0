Return-Path: <live-patching+bounces-1065-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FDF7A1D872
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 15:31:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F66C16160C
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 14:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB09D6AAD;
	Mon, 27 Jan 2025 14:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OjVNVzvr"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960F93FC7
	for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 14:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737988308; cv=none; b=lFQQdIIVBND7BGNj0/Xk5vmzxeplPf5SkTlsxCizbMTH1oyTjlkF38IBUUhr0WadTH+51A8Tr4ZQBIOF4N7E0qVHFfrRU62y1EBpW+nJhCpvL8hjIshyzjeOlXmok8p5SQHRVudlHwCntMT9zoNWlf21NkuUUq7XgYQF/XWEAGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737988308; c=relaxed/simple;
	bh=gq72t9xQ1bRKGj2BkovtB7txTTMx9dWXs5C4LIi9EKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q9S01vBaTUzCWP+hw7yv0inHlN9+UTWMsiY+/GV81GI/TX66O5QcLbCv8fJVhx90nQyh2Bxzp9j8C7En5I7dwCoinq6cKO0wnjYs5Xy2eoDMIE9qAOlvgKBoUclid/Ekdjwrqct2L0QMVOdwLRh6oOnBfjy5Q5+adUKTGSiJpXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OjVNVzvr; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d9b6b034easo8911799a12.3
        for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 06:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737988305; x=1738593105; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mDb/GhQ4TlZtuUyEoyGF/CoAJCWNs5bGdIyaITH584I=;
        b=OjVNVzvrvN62Cr7G75DxGlTmgxviCmCT1rhC8qcSjC6hq8jAFtCV+v1YemJVd/FWu9
         WijKurfFG18pAKzaJki7qTUVm1eyEXMpTsoCWideVFK+yNe08jatYvAdMOn7sVsu8LqU
         meogfX4+XcO4gTzEjD5dk54U26ghM9rIGZODsgO0tCaCoId32JRD+mYVacuk81n4xlNz
         RllGXkkUlTTWaedT7oAOo2qgeowvs6KdB/ISaGfgQu0uL93+LVUoj2KBKRASb7HlogVX
         7mbYh0A41Bv8dQXFp42jEa0QNHpLQlzO5tvDw45xsl4tvCVS5VzC6kT3WwZVLEWoDDoY
         tx7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737988305; x=1738593105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mDb/GhQ4TlZtuUyEoyGF/CoAJCWNs5bGdIyaITH584I=;
        b=pmlpR24uVJlHy2sBBJgJvH9P7HbqW1bKOAOHIPavv7QLNO8TWwBl5pF6/HBIVprtvh
         vlhpRWh7mYNNa3girEkUPQBWe85MChzmh/5Q/01hi4E+0Lcsw74LYllB28kstC1AHh43
         4xkJe4URkU6H5MCun9tvciEE9TcsquPsgShTfxnmx6r8xtYoP5/19KfR5M+OWNzO2DVi
         KX80OM8wuoBjEjHX/Mksc7fDrCgNv7TFAcSE+1VhtNK5iNBWJNIlp4A2DnCOeEw4E544
         9d1fABRSWpQ8C0jDlO4I5+KnKZFy64Lt+8V3a79tannWHF8bQgN9lbpkz8ZVdfl6ClZg
         y+OQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYJFrB7fOAP4IokbGyLmwVpIsZKGBEU0CnFlAFt7jfGpPvvz7Mi6XmdwrKO8NueesAZk3p34OxD/DOdHVT@vger.kernel.org
X-Gm-Message-State: AOJu0Yzga2UhJ7ERSBm7h3N5Wz87AwOe5VycnYjEfEAUgqTe2lYmS1K9
	rAcUIqUJrijRBHFvUJ6iswVIr+X05o20j6KRWP/RZbsVbSBzILujMid0O4apy9c=
X-Gm-Gg: ASbGncuEGtIgNMTxoLQFpBPTQfDHjkpxEpPKJBd893Ykd0EK3V/QmBQ8gwL9uHHho3A
	VQutU+uc5rWh5afB/26eTP1SEafSw+FaFdybl9JF63RqLEPNUSJ+24KDauIHK15JeLDvbeiUfe2
	XhfrnogGwrAxOolOV72Vt/Sylxw8txY3h8IsR43rV76adom43njfAxOGHi+U0zEkEecP5DmnrFt
	3N9xGaQlCLmNCeO++wMEmRFFpnu3gApmIN9iqscM4IMJ/7GvAs8PmAiRvTsiiJIck4WqGg6GV5g
	hhqFgRY=
X-Google-Smtp-Source: AGHT+IF3FIfxHgix2nKnF4oKJTIQTzZMDdI9qEwZ3cBcqN7MFxvnaUWUjb+g2+qDHnbVCbzqkWWCUQ==
X-Received: by 2002:a05:6402:2347:b0:5cf:43c1:6ba7 with SMTP id 4fb4d7f45d1cf-5db7db1d549mr40567520a12.30.1737988303643;
        Mon, 27 Jan 2025 06:31:43 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc1863ae2csm5628667a12.43.2025.01.27.06.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 06:31:43 -0800 (PST)
Date: Mon, 27 Jan 2025 15:31:41 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
Message-ID: <Z5eYzcF5JLR4o5Yl@pathway.suse.cz>
References: <20250127063526.76687-1-laoar.shao@gmail.com>
 <20250127063526.76687-3-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127063526.76687-3-laoar.shao@gmail.com>

On Mon 2025-01-27 14:35:26, Yafang Shao wrote:
> The atomic replace livepatch mechanism was introduced to handle scenarios
> where we want to unload a specific livepatch without unloading others.
> However, its current implementation has significant shortcomings, making
> it less than ideal in practice. Below are the key downsides:

[...]

> In the hybrid mode:
> 
> - Specific livepatches can be marked as "non-replaceable" to ensure they
>   remain active and unaffected during replacements.
> 
> - Other livepatches can be marked as "replaceable," allowing targeted
>   replacements of only those patches.
> 
> This selective approach would reduce unnecessary transitions, lower the
> risk of temporary patch loss, and mitigate performance issues during
> livepatch replacement.
> 
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -658,6 +658,8 @@ static int klp_add_nops(struct klp_patch *patch)
>  		klp_for_each_object(old_patch, old_obj) {
>  			int err;
>  
> +			if (!old_patch->replaceable)
> +				continue;

This is one example where things might get very complicated.

The same function might be livepatched by more livepatches, see
ops->func_stack. For example, let's have funcA and three livepatches:
a
  + lp1:
	.replace = false,
	.non-replace = true,
	.func =	{
			.old_name = "funcA",
			.new_func = lp1_funcA,
		}, { }

  + lp2:
	.replace = false,
	.non-replace = false,
	.func =	{
			.old_name = "funcA",
			.new_func = lp2_funcA,
		},{
			.old_name = "funcB",
			.new_func = lp2_funcB,
		}, { }


  + lp3:
	.replace = true,
	.non-replace = false,
	.func =	{
			.old_name = "funcB",
			.new_func = lp3_funcB,
		}, { }


Now, apply lp1:

      + funcA() gets redirected to lp1_funcA()

Then, apply lp2

      + funcA() gets redirected to lp2_funcA()

Finally, apply lp3:

      + The proposed code would add "nop()" for
	funcA() because	it exists in lp2 and does not exist in lp3.

      + funcA() will get redirected to the original code
	because of the nop() during transition

      + nop() will get removed in klp_complete_transition() and
	funcA() will get suddenly redirected to lp1_funcA()
	because it will still be on ops->func_stack even
	after the "nop" and lp2_funcA() gets removed.

	   => The entire system will start using another funcA
	      implementation at some random time

	   => this would violate the consistency model


The proper solution might be tricky:

1. We would need to detect this situation and do _not_ add
   the "nop" for lp3 and funcA().

2. We would need a more complicate code for handling the task states.

   klp_update_patch_state() sets task->patch_state using
   the global "klp_target_state". But in the above example,
   when enabling lp3:

    + funcA would need to get transitioned _backward_:
	 KLP_TRANSITION_PATCHED -> KLP_TRANSITION_UNPATCHED
      , so that it goes on ops->func_stack:
	 lp2_funcA -> lp1->funcA

   while:

    + funcA would need to get transitioned forward:
	 KLP_TRANSITION_UNPATCHED -> KLP_TRANSITION_PATCHED
      , so that it goes on ops->func_stack:
	 lp2_funcB -> lp3->funcB


=> the hybrid mode would complicate the life for both livepatch
   creators/maintainers and kernel code developers/maintainers.

   I am afraid that this complexity is not acceptable if there are
   better solutions for the original problem.

>  			err = klp_add_object_nops(patch, old_obj);
>  			if (err)
>  				return err;

I am sorry but I am quite strongly against this approach!

Best Regards,
Petr

