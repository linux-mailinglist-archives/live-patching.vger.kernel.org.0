Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C7338CEA0
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 22:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhEUUJk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 16:09:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231137AbhEUUJj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 16:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621627695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6SLlOvYcpJb9PnH2v8qQWMs/sPrQdiipYeANWUm+37s=;
        b=YEy4h6553e+gresy2kEkGJl2qP6Qqq9KqqpKcMooyE+uOe+sQaASl6nOqv8sItoMwvqsb+
        HXyZJ1F6bhZEFaVkgAktf0nJh637ngu8lFOEwCdW03Qhp423OHaXbQgqKLFFY3evPCFfIh
        c96+siNf5bZDIQ3HEf9KC4gLRuHpjo8=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-9ahittIqOSeUbySg1d3-Bw-1; Fri, 21 May 2021 16:08:09 -0400
X-MC-Unique: 9ahittIqOSeUbySg1d3-Bw-1
Received: by mail-qt1-f199.google.com with SMTP id j19-20020ac85f930000b029021f033edf60so1263803qta.10
        for <live-patching@vger.kernel.org>; Fri, 21 May 2021 13:08:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6SLlOvYcpJb9PnH2v8qQWMs/sPrQdiipYeANWUm+37s=;
        b=JwnTC1LMETVXVRrPsTz9gzEyTJ83iWvk0/ET8ZE7ysPSrTimy/pLruDnIwYPMPsZ+j
         6Kcu/gYCEw/ann5k3QeRKS767yVObacnN3d1CaXIAumyM/yGHcuqirBJff5FmwbT66mK
         HMsGGAVhsXMZqQGfm985nLu5gUu2LQZnkdbIa0dmTHwgzlu59XbVAZ2dxQ+FYn2bLBnl
         OPtYyLcU8YO0gjBwgEaRwsJWctDDcmEnEhiFqCZVKSgL8GiAyzhC4OXNqxCVCeGslb3T
         KYU37UktovqBgkWnlXoBQunV3yaXwXoTr8gp4I1cHcig5GGUo3L5w9gGRrdixNuwpul1
         zfHQ==
X-Gm-Message-State: AOAM530gXH8zpu5l7bETDYal7il7iLh58Suq1IWmx/LD0GUJ8Qc0bnly
        0+Tnrv8Vb1ozd7yVT3q1B0nS9iVdAm6rSajNJ89wFHYKlkJ18RBp5YxgND51+Iltk4E0mR5wenJ
        ge5x1WQ9mNtZpfyPRmxM9M7qJfw==
X-Received: by 2002:ad4:5f07:: with SMTP id fo7mr14729655qvb.54.1621627688942;
        Fri, 21 May 2021 13:08:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzzSaiCm9wXeWJHd3potrPtUisr0+MximgUPLbaSdQjQsFQj8zMXuNhj2iGG7ireBg86+TEw==
X-Received: by 2002:ad4:5f07:: with SMTP id fo7mr14729622qvb.54.1621627688639;
        Fri, 21 May 2021 13:08:08 -0700 (PDT)
Received: from treble ([68.52.236.68])
        by smtp.gmail.com with ESMTPSA id y8sm5334555qtn.61.2021.05.21.13.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 13:08:08 -0700 (PDT)
Date:   Fri, 21 May 2021 15:08:06 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Brown <broonie@kernel.org>, mark.rutland@arm.com,
        ardb@kernel.org, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210521200806.nk3m7aldelmi3l2r@treble>
References: <20210521161117.GB5825@sirena.org.uk>
 <a2a32666-c27e-3a0f-06b2-b7a2baa7e0f1@linux.microsoft.com>
 <20210521174242.GD5825@sirena.org.uk>
 <26c33633-029e-6374-16e6-e9418099da95@linux.microsoft.com>
 <20210521175318.GF5825@sirena.org.uk>
 <20210521184817.envdg232b2aeyprt@treble>
 <74d12457-7590-bca2-d1ce-5ff82d7ab0d8@linux.microsoft.com>
 <20210521191140.4aezpvm2kruztufi@treble>
 <20210521191608.f24sldzhpg3hyq32@treble>
 <bf3a5289-8199-b665-0327-ed8240dd7827@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bf3a5289-8199-b665-0327-ed8240dd7827@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 21, 2021 at 02:41:56PM -0500, Madhavan T. Venkataraman wrote:
> > Or is frame->reliable supposed to be checked after all?  Looking at the
> > code again, I'm not sure.
> > 
> > Either way it would be good to document the interface more clearly in a
> > comment above the function.
> > 
> 
> So, arch_stack_walk_reliable() would do this:
> 
> 	start_backtrace(frame);
> 
> 	while (...) {
> 		if (!frame->reliable)
> 			return error;
> 
> 		consume_entry(...);
> 
> 		ret = unwind_frame(...);
> 
> 		if (ret)
> 			break;
> 	}
> 
> 	if (ret == -ENOENT)
> 		return success;
> 	return error;
> 
> 
> Something like that.

I see.  So basically there are six possible combinations of return
states:

  1) No error		frame->reliable
  2) No error		!frame->reliable
  3) -ENOENT		frame->reliable
  5) -ENOENT		!frame->reliable (doesn't happen in practice)
  4) Other error	frame->reliable  (doesn't happen in practice)
  6) Other error	!frame->reliable


On x86 we have fewer combinations:

  1) No error		state->error
  2) No error		!state->error
  3) Error		state->error
  4) Error		!state->error (doesn't happen in practice)


I think the x86 interface seems more robust, because it's more narrow
and has fewer edge cases.  Also it doesn't have to distinguish between
error enums, which can get hairy if a downstream callee happens to
return -ENOENT for a different reason.

-- 
Josh

