Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D207E47089C
	for <lists+live-patching@lfdr.de>; Fri, 10 Dec 2021 19:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239075AbhLJS2h (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 Dec 2021 13:28:37 -0500
Received: from mail-qt1-f171.google.com ([209.85.160.171]:34353 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239276AbhLJS2h (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 Dec 2021 13:28:37 -0500
Received: by mail-qt1-f171.google.com with SMTP id o17so9231071qtk.1;
        Fri, 10 Dec 2021 10:25:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3ncRAC5NMmHYdYgIiX+rV/e8ReKPYkC25NOZUAGrVHg=;
        b=rDewzmHVvHF6d3osQeiQBdTi8SJgBVcH7NjW4wZPx8TJSSzT52US0OwKCqCsQ65DbN
         Myfbn49+uY5X4PZackbxNEmBsZS9w2emjiOc46WCUzgGbE9FmSnYbsE9rF0dcg8FPMwu
         6K2atFhlNZDZ84mD1gD8CDh8nzux3p26E7P94vR7S2j3jkP5eGNuHkTWHScYNUmXK/JY
         d5WBMBcej38KYf9NKHsm2wVF0gYcNhX2lEmnF8kVOXrqEOcQf4GwdqzEUN9nCcVNVMVV
         gCaUw/8W76oUL8oN5m/1EZrqAuwRIHK/w2UBkozaB2X9HlMJbRuGrf9GCTpXUnSP64Tp
         rPLw==
X-Gm-Message-State: AOAM532CZpO86T+8m58IkCF+XvjYeahTZzd4JDJXtafUbCdWea7PnFC2
        IXAeImGByo+uogeS/QdsTSM=
X-Google-Smtp-Source: ABdhPJxYVZ/SvxezzuNIV7iBJ1zbboQXukAzXTVTGWoGA3nKX/NqayjQPgoPMjKK3KSF9tSlgaq8ug==
X-Received: by 2002:a05:622a:92:: with SMTP id o18mr28895047qtw.570.1639160701158;
        Fri, 10 Dec 2021 10:25:01 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-118.fbsv.net. [2a03:2880:20ff:76::face:b00c])
        by smtp.gmail.com with ESMTPSA id s7sm2633583qta.31.2021.12.10.10.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 10:25:00 -0800 (PST)
Date:   Fri, 10 Dec 2021 10:24:58 -0800
From:   David Vernet <void@manifault.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     linux-doc@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] Documentation: livepatch: Add kernel-doc link to
 klp_enable_patch
Message-ID: <YbObeiWbLxO8MwrD@dev0025.ash9.facebook.com>
References: <20211209165303.3205464-1-void@manifault.com>
 <YbMc8YGIoyRU5nwJ@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbMc8YGIoyRU5nwJ@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Petr Mladek <pmladek@suse.com> wrote on Fri [2021-Dec-10 10:25:05 +0100]:
> 
> Honestly, I do not like this. It might be acceptable when it converts
> klp_enable_patch() into a link pointing to another page describing the API.
> 
> But this patch causes the entire documentation of klp_enable_patch()
> inserted into livepatch.html. It does not fit there and breaks
> the text flow.

Thank you for taking a look at the patch, Petr.

I'm happy to revise the patch to instead add a new `api.rst` file that
contains the `kernel-doc` directive, which would cause `klp_enable_patch()`
in `livepatch.rst` to automatically link to the separate page as you
suggested.

Just to check though -- I see that `shadow-vars.rst` and `system-state.rst`
have their own "API" sections. Is it preferable to add such a section
directly to `livepatch.rst`, rather than creating a separate file?

Let me know either way and I'll send a v2 patch with your preference.

Kind regards,
David
