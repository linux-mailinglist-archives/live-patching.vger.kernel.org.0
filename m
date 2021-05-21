Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AC538CE04
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 21:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhEUTNO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 15:13:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235033AbhEUTNO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 15:13:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621624310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nz98kMsw+FzS8L01GR0w0EVxwdrTPL2Z/BYSCEvqIsc=;
        b=fjkKymjtuLZbkMOkr+7QaPUc/QpeJsxHgZZZhSj7YvA87njoJxYtVq6ZI9DjTFRx2xuxP9
        Ka8O/Now85qoR/rSqmkpjJVsfUpTYC34qTEzMgmZv/V4hjxxONekjX7z9YwGbjpGZqk7PV
        kUTq3a6n4SE4pfbh0HumIZ414gUBYUM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-3UvYNvHpOaSNlcb0cB4i-A-1; Fri, 21 May 2021 15:11:45 -0400
X-MC-Unique: 3UvYNvHpOaSNlcb0cB4i-A-1
Received: by mail-qk1-f197.google.com with SMTP id s123-20020a3777810000b02902e9adec2313so17571534qkc.4
        for <live-patching@vger.kernel.org>; Fri, 21 May 2021 12:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nz98kMsw+FzS8L01GR0w0EVxwdrTPL2Z/BYSCEvqIsc=;
        b=brJI+FovTawzxCrdnakXc0TPNh6M3y8tYs9otPtDEtzM5x2bh/JtgKFJ03KIAAauhs
         o6Qx6Haf4hxvieZdXmed4t1MAf/ZHZ0J0liDYweJFa8NUF2GWLUxhGgO0Co6qBp+8TkE
         4cfimWImp4kPv7xiIJUuQihyeRjNozostTrz36MfYes+wxcL8UVpnKYCgRrKEh55DtM7
         FOYyx7O18Tlg+zwKsGJGJ32e9uySTq4IAzYHQrrP6mF/v9/NHzatZh+HWV5KfrPGdHDt
         ZEf/S+qbg+OI/H3ZBJQStsKW1mDpr3pm/8i56BGQQXRQ56Hf0v8P17aYUe9euUtmYOBR
         WlbA==
X-Gm-Message-State: AOAM532NloWzSlZBiOu3bWooyRl/WcR56hvGwIkemKDAtKkTrq+8EVCC
        +CCxungsXchaphFZLQ9yVFf/drxNaBGDyilzYpuN4+bs5JNzXsS8jRHChwK8ZAaUuVJ5irK6630
        4131u3CUmPdFmNUcPZwgo+psvWw==
X-Received: by 2002:ad4:5281:: with SMTP id v1mr14776332qvr.56.1621624305393;
        Fri, 21 May 2021 12:11:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjZKT1phiUkfEYMYpJ5BVtH7F+86BAqoH6+mVzJaZJ5h4g+DjOWLKk81axhj747gk8xhKokw==
X-Received: by 2002:ad4:5281:: with SMTP id v1mr14776295qvr.56.1621624305075;
        Fri, 21 May 2021 12:11:45 -0700 (PDT)
Received: from treble ([68.52.236.68])
        by smtp.gmail.com with ESMTPSA id a27sm3922191qtn.97.2021.05.21.12.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 12:11:44 -0700 (PDT)
Date:   Fri, 21 May 2021 14:11:40 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Brown <broonie@kernel.org>, mark.rutland@arm.com,
        ardb@kernel.org, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210521191140.4aezpvm2kruztufi@treble>
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210516040018.128105-2-madvenka@linux.microsoft.com>
 <20210521161117.GB5825@sirena.org.uk>
 <a2a32666-c27e-3a0f-06b2-b7a2baa7e0f1@linux.microsoft.com>
 <20210521174242.GD5825@sirena.org.uk>
 <26c33633-029e-6374-16e6-e9418099da95@linux.microsoft.com>
 <20210521175318.GF5825@sirena.org.uk>
 <20210521184817.envdg232b2aeyprt@treble>
 <74d12457-7590-bca2-d1ce-5ff82d7ab0d8@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <74d12457-7590-bca2-d1ce-5ff82d7ab0d8@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 21, 2021 at 01:59:16PM -0500, Madhavan T. Venkataraman wrote:
> 
> 
> On 5/21/21 1:48 PM, Josh Poimboeuf wrote:
> > On Fri, May 21, 2021 at 06:53:18PM +0100, Mark Brown wrote:
> >> On Fri, May 21, 2021 at 12:47:13PM -0500, Madhavan T. Venkataraman wrote:
> >>> On 5/21/21 12:42 PM, Mark Brown wrote:
> >>
> >>>> Like I say we may come up with some use for the flag in error cases in
> >>>> future so I'm not opposed to keeping the accounting there.
> >>
> >>> So, should I leave it the way it is now? Or should I not set reliable = false
> >>> for errors? Which one do you prefer?
> >>
> >>> Josh,
> >>
> >>> Are you OK with not flagging reliable = false for errors in unwind_frame()?
> >>
> >> I think it's fine to leave it as it is.
> > 
> > Either way works for me, but if you remove those 'reliable = false'
> > statements for stack corruption then, IIRC, the caller would still have
> > some confusion between the end of stack error (-ENOENT) and the other
> > errors (-EINVAL).
> > 
> 
> I will leave it the way it is. That is, I will do reliable = false on errors
> like you suggested.
> 
> > So the caller would have to know that -ENOENT really means success.
> > Which, to me, seems kind of flaky.
> > 
> 
> Actually, that is why -ENOENT was introduced - to indicate successful
> stack trace termination. A return value of 0 is for continuing with
> the stack trace. A non-zero value is for terminating the stack trace.
> 
> So, either we return a positive value (say 1) to indicate successful
> termination. Or, we return -ENOENT to say no more stack frames left.
> I guess -ENOENT was chosen.

I see.  So it's a tri-state return value, and frame->reliable is
intended to be a private interface not checked by the callers.

That makes sense, and probably fine, it's just perhaps a bit nonstandard
compared to most Linux interfaces.

-- 
Josh

