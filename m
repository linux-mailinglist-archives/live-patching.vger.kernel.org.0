Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA5477577
	for <lists+live-patching@lfdr.de>; Thu, 16 Dec 2021 16:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhLPPOb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Dec 2021 10:14:31 -0500
Received: from mail-qv1-f41.google.com ([209.85.219.41]:38887 "EHLO
        mail-qv1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbhLPPOa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Dec 2021 10:14:30 -0500
Received: by mail-qv1-f41.google.com with SMTP id o10so3193636qvc.5;
        Thu, 16 Dec 2021 07:14:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bgrHajWI1E3M+PmnYwKwkGRt8FZTO6H90ocP/ndri7g=;
        b=l4/TQy7Mj6dZViQX7nuX7IGxDo14fv08yEdtRQUDDtCROBIhbaQFG4kzBxPZs5Xsfl
         jTUCIHP0BB6mF5tTsIE3S9gTKeZUmQf+i02csTuX0oqvXYMN3mNEAPqTWyNtWXyKPl5/
         dhz8lm1Ldml5a/uGIPF3+qBa8fQmQ80lSnpTb25K+nTNvFXSGKR23VY7tMGnmGG1diGd
         jmd5tb/++S2w8s0UTQ2gNSCoa3BFRCekWlVN8Oqip5Q66o2hu+nlSbIgVUljYCHxcbe3
         9RAh9vIBtlZThkyEDVYHsX/GBOIwseUau2aF+dZKQid/B+pe1Gv3sCJM2dTcot2ERtvR
         Qckw==
X-Gm-Message-State: AOAM530yP/raaw0wdCeNCgDmFCs03qI8LIgxZovqiy5MHslXIWU7jQc2
        dorKYaPu+VYu6qIAZZuy2BI=
X-Google-Smtp-Source: ABdhPJw6GiedDkWdRX6nQO/Lqr8qnOaiR3jLCXF/GKgiSqYuvi6bzOzmdpTW1OoFQLVgoyIknYzdwg==
X-Received: by 2002:a05:6214:c47:: with SMTP id r7mr16349557qvj.51.1639667669658;
        Thu, 16 Dec 2021 07:14:29 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-027.fbsv.net. [2a03:2880:20ff:1b::face:b00c])
        by smtp.gmail.com with ESMTPSA id j22sm2892324qko.68.2021.12.16.07.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 07:14:29 -0800 (PST)
Date:   Thu, 16 Dec 2021 07:14:27 -0800
From:   David Vernet <void@manifault.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Miroslav Benes <mbenes@suse.cz>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <YbtX088SeDWaEih1@dev0025.ash9.facebook.com>
References: <20211213191734.3238783-1-void@manifault.com>
 <YbhZwVocHDX9ZBAc@alley>
 <alpine.LSU.2.21.2112141012090.20187@pobox.suse.cz>
 <Ybi3qcA5ySDYpyib@dev0025.ash9.facebook.com>
 <Ybi9NzbvWU7ka8m1@kroah.com>
 <YbmlL0ZyfSuek9OB@alley>
 <YboLPAmOc8/6khu2@kroah.com>
 <YbtJzonSJjcUaUwh@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbtJzonSJjcUaUwh@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Petr Mladek <pmladek@suse.com> wrote on Thu [2021-Dec-16 15:14:38 +0100]:
> > Now it does.  In the past, I think we did create some memory.  I know
> > when we hook debugobjects up to kobjects (there's an external patch for
> > that floating around somewhere), that is one reason to keep the
> > kobject_put() rule, and there might have been other reasons in the past
> > 20+ years as well.
> > 
> > So yes, while you are correct today, the "normal" reference counted
> > object model patern is "after the object is initialized, it MUST only be
> > freed by handling its reference count."  So let's stick to that rule for
> > now.
> 
> Good point.

Thanks for the discussion all. I think we've landed on the fact that this
is a refcounting bug that needs to be fixed, but isn't a leak in how the
kobject implementation exists today.

Petr - are you OK with me sending out a v3 of the patch with the following
changes:
  - The patch description is updated to not claim that a leak is being
    fixed, but rather that a kobject reference counting bug is being fixed.
  - All of the NULL checking in klp_init_patch_early() is brought into
    klp_enable_patch(), and klp_init_patch_early() is updated to be void,
    per Josh's suggestion. This would address the refcounting issue and IMO
    also simplifies and improves the code. I know you were onboard with
    moving try_module_get() into klp_enable_patch(), but I don't think we
    ever resolved the point about moving the rest of the NULL checking out
    as well.

Regards,
David
