Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A085477535
	for <lists+live-patching@lfdr.de>; Thu, 16 Dec 2021 16:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbhLPPAn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Dec 2021 10:00:43 -0500
Received: from mail-qt1-f171.google.com ([209.85.160.171]:38726 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238151AbhLPPAn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Dec 2021 10:00:43 -0500
Received: by mail-qt1-f171.google.com with SMTP id 8so25687128qtx.5;
        Thu, 16 Dec 2021 07:00:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5oSY/vy26QicgktViTKXbYxC1IX5RdpXzoBLbf2PyRY=;
        b=Tp6wLDqa+igVznXFFWQ2M5nlws1YiF5bMxs2pjpY/fujveqDwFOVuH1Dyw1VUdg86s
         EqsGYJTvgqJYplJFMhBQuNg43F6K8J6coRJWehS1BWbNcom428cErOX3OPK7oWi5JZrQ
         FfL7S3rfj2Dci+jS6GVIGPr2Zpyk1lz+9dBhZ1ipHCb41qqY37UNlry26utOf27kLKnb
         bItGqOFTXGiifFeDf2CDF2d3ppoCoIn5Tf4TZkVpsXiuvQgErO7XJVLCVxvy8S4rkvt8
         NmC5qiV0kA59rjilXMFATTh3D/7VwR+cc+w8VSBmuKKpmdHYwYfDGnWUKcX1YX346EhA
         FKCw==
X-Gm-Message-State: AOAM533m5IaIo8s2nyWdTk4yMyB1U2AGMI3NNfNcQPUYcj0wgVfv+kO9
        AWXY4pzPI8MO3cc2MX2APuI=
X-Google-Smtp-Source: ABdhPJyGbHPlJk0cycMNtJA/NhQqtXs4W8loZWOEuIHC+Z1fiSUyJa4Pb793SWa4rTfqODxZtga2JA==
X-Received: by 2002:a05:622a:1484:: with SMTP id t4mr17109961qtx.57.1639666840544;
        Thu, 16 Dec 2021 07:00:40 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-000.fbsv.net. [2a03:2880:20ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id y15sm2909764qko.74.2021.12.16.07.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 07:00:40 -0800 (PST)
Date:   Thu, 16 Dec 2021 07:00:38 -0800
From:   David Vernet <void@manifault.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, joe.lawrence@redhat.com, corbet@lwn.net
Subject: Re: [PATCH v2] Documentation: livepatch: Add livepatch API page
Message-ID: <YbtUlkaWSQf4yCIb@dev0025.ash9.facebook.com>
References: <20211215174659.2332589-1-void@manifault.com>
 <YbsNcAKzRCxGqXUA@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbsNcAKzRCxGqXUA@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Petr Mladek <pmladek@suse.com> wrote on Thu [2021-Dec-16 10:57:04 +0100]:

> This change is not good. The function releases all existing shadow
> variables with the given @id for any @obj. And it is not longer clear.

Good point. I'll address that in v3.

> I guess that the primary motivation was to remove  "Inline emphasis
> start-string without end string" mentioned in the commit message.

Yes, this was the primary and only motivation. <*, id> is much clearer and I'm
with you on finding a better alternative.

> A solution would be replace '*' with something else, for example, < , id>.

I think this is better than just obj, but in my opinion this may be confusing
for readers and look like a typo. I think I prefer your second suggestion,
though obj really makes more sense in the case where we're actually passing an
@obj to the function. I'll probably (deservedly?) get lambasted for suggesting
this, but what about taking a page out of rust's book and doing something like
this:

  * klp_shadow_free_all() - detach and free all <_, id> shadow variables
  *		with the given @id.

to indicate that in this case we don't care about the obj. Even for a reader
unfamiliar with rust, hopefully it would get the point across.

> Another solution would be to describe it another way, for example:
> 
>  * klp_shadow_free_all() - detach and free all <obj, id> shadow variables
>  *		with the given @id.

I'm fine with this as well. Let me know what you think about <_, id> vs. what
you suggested, and I'll send out the v3 patch with your preference.

> BTW: There is likely the same problem in Documentation/livepatch/shadow-vars.rst.
>      I see <*, id> there as well.

Indeed you're correct. There's no warning in the build system because there
happen to be two <*, id> ... <*, id> in a row, so rst happily italicizes what's
between them without question. I'll fix this in the v3 of the patch as well.

> Otherwise, the patch looks fine to me.

Thanks for taking a look and for the helpful suggestions.

- David
