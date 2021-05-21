Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E7538CDC2
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 20:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhEUStr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 14:49:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230238AbhEUStp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 14:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621622902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RabyVfBo+mpfsjY1+7E6nJCVxTgd3EWR2ZAwlRxq+pc=;
        b=Y2IsRGNeZjn2kdz60/scONy4y8CaNQA/h36bJ16rReIjciHxN+rRM3Sxh52hNCoTAKP6Q4
        mcez0/di82FyILM9MrkO408Qe/IaepD17CTpIkSNrzv2QPTI4kKmj6ctyEEHyADgwARm7i
        +9iMFbAkRZB+KbZJ/so33wBLmrlE+1M=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-UWFCFJ8_Np6JwsV6CbRYKw-1; Fri, 21 May 2021 14:48:20 -0400
X-MC-Unique: UWFCFJ8_Np6JwsV6CbRYKw-1
Received: by mail-qv1-f72.google.com with SMTP id d9-20020a0ce4490000b02901f0bee07112so11601548qvm.7
        for <live-patching@vger.kernel.org>; Fri, 21 May 2021 11:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RabyVfBo+mpfsjY1+7E6nJCVxTgd3EWR2ZAwlRxq+pc=;
        b=E27R4nRVndcHdBqggi4WOAITrthSE8Dx8SbpnX7HVhMaj798pO759JPFwYgyGsx5Wq
         opXKWPla9ep4X3fygdA/ZrG8bKn2VfxkJ4xx163Ha/r5wHfh8rF3CQkK8EZ+fivh1BGo
         dzu3jtEgPtdiwqKNYLiLPAGjtKux3YwCt989He7KgExbhaxn2rex8O5XWE/rZDAUohyp
         2CL6rh8v6Pm8qa7CT5JyVyJC1oOEilJiKESGIyByS/UzKfLrHcBumn0b46y26SfTV//3
         71CzKcZTO6xZXYwnXt+540euLPEyWlugwbxrHQ5YGg+f9oa01DXX/DU0Ymx38XzGmPWZ
         46Cw==
X-Gm-Message-State: AOAM530U3rD1o/4e38FapvCxt8NkceG5gr08S78uI2+qOf2Sxa/MTY5+
        /bH4fMT3C+FisLQ+QdkQiUIw3ZzUmDqqL3uvaYC5Fhjge34ebgzwYqBwozUWGAJrYuYZUK6Iv48
        CuOs8wzxCJiQK002d7f9dU9L2ag==
X-Received: by 2002:a37:a751:: with SMTP id q78mr12984109qke.482.1621622900182;
        Fri, 21 May 2021 11:48:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHUdKGd/QZYK8u/xAP/LmgxaXU5otdxg4YYZcyca15w45dlnEX1TLWZZcpl0Zm9M20jsvUSA==
X-Received: by 2002:a37:a751:: with SMTP id q78mr12984080qke.482.1621622899919;
        Fri, 21 May 2021 11:48:19 -0700 (PDT)
Received: from treble ([68.52.236.68])
        by smtp.gmail.com with ESMTPSA id b17sm4762548qtb.78.2021.05.21.11.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 11:48:19 -0700 (PDT)
Date:   Fri, 21 May 2021 13:48:17 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        mark.rutland@arm.com, ardb@kernel.org, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210521184817.envdg232b2aeyprt@treble>
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210516040018.128105-2-madvenka@linux.microsoft.com>
 <20210521161117.GB5825@sirena.org.uk>
 <a2a32666-c27e-3a0f-06b2-b7a2baa7e0f1@linux.microsoft.com>
 <20210521174242.GD5825@sirena.org.uk>
 <26c33633-029e-6374-16e6-e9418099da95@linux.microsoft.com>
 <20210521175318.GF5825@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210521175318.GF5825@sirena.org.uk>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 21, 2021 at 06:53:18PM +0100, Mark Brown wrote:
> On Fri, May 21, 2021 at 12:47:13PM -0500, Madhavan T. Venkataraman wrote:
> > On 5/21/21 12:42 PM, Mark Brown wrote:
> 
> > > Like I say we may come up with some use for the flag in error cases in
> > > future so I'm not opposed to keeping the accounting there.
> 
> > So, should I leave it the way it is now? Or should I not set reliable = false
> > for errors? Which one do you prefer?
> 
> > Josh,
> 
> > Are you OK with not flagging reliable = false for errors in unwind_frame()?
> 
> I think it's fine to leave it as it is.

Either way works for me, but if you remove those 'reliable = false'
statements for stack corruption then, IIRC, the caller would still have
some confusion between the end of stack error (-ENOENT) and the other
errors (-EINVAL).

So the caller would have to know that -ENOENT really means success.
Which, to me, seems kind of flaky.

BTW, not sure if you've seen what we do in x86, but we have a
'frame->error' which gets set for an error, and which is cumulative
across frames.  So non-fatal reliable-type errors don't necessarily have
to stop the unwind.  The end result is the same as your patch, but it
seems less confusing to me because the 'error' is cumulative.  But that
might be personal preference and I'd defer to the arm64 folks.

-- 
Josh

