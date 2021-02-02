Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E80730C81C
	for <lists+live-patching@lfdr.de>; Tue,  2 Feb 2021 18:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbhBBRlf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Feb 2021 12:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236850AbhBBRjb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Feb 2021 12:39:31 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC70C061786;
        Tue,  2 Feb 2021 09:38:51 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id k9so2083658vsr.3;
        Tue, 02 Feb 2021 09:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eHAW1mrB7zvHhh97f0tcropb/e113NgWFEAjP6gLbCQ=;
        b=P5+gYqPz5l2mFlVKQREHmz6Kr0fA/RiH9maBRKb+UIPpLrmJCqO0uZtlprkvOcVC7R
         zfLNlUQD86NkP+ifjcEWmIBbuauC+qpY41TpCmhwHtmog0l7nn9JmHrn+u+THmtLIdRH
         0KnCTzdZzCy8vq0biUzKHV1wh4EBiZ9oAhpnAVrPJLt++k/V0XTB8bMDbd3Qdhisf4xn
         zldT4XKEDyVCBwD/nZj1eNAdMGt3Bg7tXjS8x0Jxcv2kvkr0eEq97P/HBzukApwh349g
         hMt5JK//cZJtHt8GTmxsjoMa4oHwEaTmQsEBjy8RLtIA7UYf87pdqgL7wYkBBpfw2voR
         5vXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eHAW1mrB7zvHhh97f0tcropb/e113NgWFEAjP6gLbCQ=;
        b=EEPLiruZAjwDyUNhI3I0Aq4rxZzHGpOR48riK5CymnbhOiI4SJ5LlMu3E21H/vHNs2
         4f2uWrVnonZI+uTNTOdcnE2pcbEm0YGJr3/KqSfnSERwhntFKF5ntw2IszhvXxiTtUL4
         f+duxiSQ2tRyW+m9Gz+GOSGjw9ArEH4LKTXhejKqHhERM2NSu+BS76Iy66mFGwvPG/jv
         W1aQcDTF8PJ6zrJwvgKxziVtKAnHiZwbjyGzqOV0xpBloeS6N7FiYYZ5v+pp7EbZUBUK
         btloJpylj/SRlmPn2rq1J5fJkqb+6/SalZ8eLHZUxsDI693ii0mYdZs0CzLA8h6lqVBH
         TlSg==
X-Gm-Message-State: AOAM531abkMtLsc5c1kX24uRJ7VmlyLQS8jCOaKNLlwcuDRjpXt90GXW
        gbXqJnYWZJf16Gi7jsEtnbfV9Zni3eCYtp96Ick=
X-Google-Smtp-Source: ABdhPJxr6UuPLfiTQWU0PtI4KjGAd7lT5wP47Eg2A5ysqKhDWcwimMgCtP8JDHk8rXFO/C2SX4AsHulH76L2ZXyS3BI=
X-Received: by 2002:a05:6102:96:: with SMTP id t22mr13599418vsp.22.1612287530852;
 Tue, 02 Feb 2021 09:38:50 -0800 (PST)
MIME-Version: 1.0
References: <20210202121334.1361503-1-hch@lst.de> <YBljkDgMFcqKcH8H@gunter>
In-Reply-To: <YBljkDgMFcqKcH8H@gunter>
From:   Emil Velikov <emil.l.velikov@gmail.com>
Date:   Tue, 2 Feb 2021 17:38:39 +0000
Message-ID: <CACvgo50f0d9fYZ+n4nSBOCgaGpe=x6_tfXPPGB2FiDVwGgaAJA@mail.gmail.com>
Subject: Re: module loader dead code removal and cleanups v3
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        linux-kbuild@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Michal Marek <michal.lkml@markovi.net>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Miroslav Benes <mbenes@suse.cz>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Jessica,

On Tue, 2 Feb 2021 at 14:37, Jessica Yu <jeyu@kernel.org> wrote:
>
> +++ Christoph Hellwig [02/02/21 13:13 +0100]:
> >Hi all,
> >
> >this series removes support for long term unused export types and
> >cleans up various loose ends in the module loader.
> >
> >Changes since v2:
> > - clean up klp_find_object_symbol a bit
> > - remove the now unused module_assert_mutex helper
> >
> >Changes since v1:
> > - move struct symsearch to module.c
> > - rework drm to not call find_module at all
> > - allow RCU-sched locking for find_module
> > - keep find_module as a public API instead of module_loaded
> > - update a few comments and commit logs
>
> Thanks Christoph for cleaning up all that aged cruft, and thanks everyone
> for the reviews.
>
> I was curious about EXPORT_SYMBOL_GPL_FUTURE and EXPORT_UNUSED_SYMBOL
> variants, and found that most of that stuff was introduced between
> 2006 - 2008. All the of the unused symbols were removed and gpl future
> symbols were converted to gpl quite a long time ago, and I don't
> believe these export types have been used ever since. So I
> think it's safe to retire those export types now.
>
I believe you're spot on - based on reading through git log and
checking the ML archives.

Shame I didn't get to finish a similar series I had locally. Patches
11-13 match what I have here so:
Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>

HTH
-Emil
