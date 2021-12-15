Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5F7475BBE
	for <lists+live-patching@lfdr.de>; Wed, 15 Dec 2021 16:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243907AbhLOPUN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Dec 2021 10:20:13 -0500
Received: from mail-qv1-f51.google.com ([209.85.219.51]:43627 "EHLO
        mail-qv1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243891AbhLOPUH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Dec 2021 10:20:07 -0500
Received: by mail-qv1-f51.google.com with SMTP id m6so3409280qvh.10;
        Wed, 15 Dec 2021 07:20:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qmub5xNOOJMDe8hIhM9h8/alEATciJeF8DyioMLtUB8=;
        b=arHfkLE/oMXuj9Vhp/EzfzhoQuipuI2DFL1hrz49sbPBSAQvq5iY95Ag74kc51IBCU
         ay/5B150LwAT9hJkaLQVLAgBCw+MfvZ2+rWgLGCtLwHxH0V8TUCfo5cybFkZ7xLkg5eH
         7+Z5b6nDVhAqZ7H3hb9qL/hV2p5D3omhFn5CpAlqaO46pFqhB/VcPSxBdjx8+0GjUT1z
         Zz1JajOvZX8uVJ2p8bERhzDoMebYFzEd7dGuSyhUetBNPM/CVS+Vg9ThImZe09pdBy/y
         eC/8wiZVEZhIO9poPOjhbamVxuBqnRAtyvQevjSuBvfTe8gPrq74DOqHeU3WeAWBT4Uy
         FAgA==
X-Gm-Message-State: AOAM532oLwhVKr517VpLaW7VLESrin/+fhFL4ghG00qk0jktXWE+Tx6D
        wHKc0fhW+/53icCPMOakXog=
X-Google-Smtp-Source: ABdhPJwpKCZQHgXCQtJRVjQxiaairOVcdTec8dAbnr0GZQTF2BkohLdy9oVEhVmjwIjxFEe3RMlV0w==
X-Received: by 2002:a0c:f6ca:: with SMTP id d10mr6572282qvo.48.1639581606603;
        Wed, 15 Dec 2021 07:20:06 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-004.fbsv.net. [2a03:2880:20ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id a16sm1640986qta.94.2021.12.15.07.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 07:20:06 -0800 (PST)
Date:   Wed, 15 Dec 2021 07:20:04 -0800
From:   David Vernet <void@manifault.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        corbet@lwn.net, songliubraving@fb.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] livepatch: Fix leak on klp_init_patch_early failure
 path
Message-ID: <YboHpHmu3D+0hxKp@dev0025.ash9.facebook.com>
References: <20211214220124.2911264-1-void@manifault.com>
 <20211214235128.ckaozqsvcr6iqcnu@treble>
 <Ybm+FyhLnuH4JThq@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybm+FyhLnuH4JThq@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Petr Mladek <pmladek@suse.com> wrote on Wed [2021-Dec-15 11:06:15 +0100]:
> Well, I still believe that this is just a cargo cult. And I would prefer
> to finish the discussion about it, first, see
> https://lore.kernel.org/all/YbmlL0ZyfSuek9OB@alley/

No problem, I won't send out v3 until we've finished the discussion and
have consensus. I'll assume that the discussion on whether or not there is
a leak will continue on the thread you linked to above, so I won't comment
on it here.

> Note that klp_init_*_early() functions iterate through the arrays
> using klp_for_each_*_static. While klp_free_*() functions iterate
> via the lists using klp_for_each_*_safe().

Correct, as I've understood it, klp_for_each_*_safe() should only iterate
over the objects that have been added to the patch and klp_object's lists,
and thus for which kobject_init() has been invoked. So if we fail a check
on 'struct klp_object' N, then we'll only iterate over the first N - 1
objects in klp_for_each_*_safe().

> We should not need the pre-early-init check when the lists include only
> structures with initialized kobjects.

Not sure I quite follow. We have to do NULL checks for obj->funcs at some
point, and per Josh's suggestion it seems cleaner to do it outside the
critical section, and before we actually invoke kobject_init(). Apologies
if I've misunderstood your point.

> Otherwise, I like the idea to do module_get() before
> klp_init_patch_early(). I was never happy with the "hidden"
> side effect.

Ack!

> I am also fine with calling klp_free() when the early init fails
> if we agreed that it is a good practice. I just do want to pretend
> that it fixes a leak what nobody sees any leak.
> 
> Please, wait few days until the discussion finishes before sending v3.

Ack, no problem, I'll wait until we're all in alignment. Thanks, Petr and
Josh for taking a look at the patch.

Regards,
David
