Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABE92FE538
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 09:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbhAUIk3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 03:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbhAUIkL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 03:40:11 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C2DC061575
        for <live-patching@vger.kernel.org>; Thu, 21 Jan 2021 00:39:30 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id n186so1359245oia.5
        for <live-patching@vger.kernel.org>; Thu, 21 Jan 2021 00:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kUfE6SE2n4SlWhNh9yX+hYT59DeJtvAevoxz9O0TUik=;
        b=TMAYX7QpeIeo0SfI4thWj5+xPv0DebVU+jxpSwtXWWoVQE84U3WmqKHg2Qft1tihQW
         DB2oOS44TFmyBNUiPyczVFFVRDnnzX7CXxrO4CSZqhf86MPvPEoVPiCfYRdJkxCu76vO
         imVq/j+2Imm/U2YKA+alPP8NkHUHRvLDmkeRU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kUfE6SE2n4SlWhNh9yX+hYT59DeJtvAevoxz9O0TUik=;
        b=ieE/bLBXFR6zlHX8MGnFtw1E2pyo5sirTVEf4k9fO0grkvfhsbKatdwpQ0V3J1MsIx
         2Pi2l4BKaU/+MWOgByJ0k1+MQPJpOeOAW/WAK8DL8dWDRHaYj2gKoKkuKbMDAUPuSLJj
         ZgMLk64DwZRatprEIrgWgkWx/LiDDmD/sdi66gx8d9kea4vPi9imrIMoYYn33tF/NOLt
         49Qz6kBNSehj0zessmHdGJJxh9yw6P9bRdVY46jDxUIBCUJ4Dnv+1TZ7mo6IutTte24U
         +yO6Esdmiwxf/AcHs8owwny7lKZ1D1iKWwGLhUon09Yz9yDkHEslcYfLvybxAYsm4XFe
         8Cyg==
X-Gm-Message-State: AOAM533noRye9pWWgpntzaUH2GR1vDbswxj8QazkY0AmSyvuwiwVSeeM
        mIr4tz+0IopBrn33qs8uEwU07/ahTwcpK/b8PWyd1w==
X-Google-Smtp-Source: ABdhPJwdBtD3B1cBobpcMyhJG7mZaplWKuBOFYhagzM+X5GOmA44nSE9377UdftyPqlQOfXqfDOSago3v5JpojgiclM=
X-Received: by 2002:aca:ad92:: with SMTP id w140mr5422725oie.128.1611218370352;
 Thu, 21 Jan 2021 00:39:30 -0800 (PST)
MIME-Version: 1.0
References: <20210121074959.313333-1-hch@lst.de> <20210121074959.313333-9-hch@lst.de>
 <CAKMK7uFo3epNAUdcp0vvW=VyWMMTZghGyRTPbz_Z37S6nem_2A@mail.gmail.com> <20210121082820.GA25719@lst.de>
In-Reply-To: <20210121082820.GA25719@lst.de>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Thu, 21 Jan 2021 09:39:19 +0100
Message-ID: <CAKMK7uHKwpjTC8DZ=yDtHpEaLXN7D5C+mOGK52jjkdR=6vib3Q@mail.gmail.com>
Subject: Re: [PATCH 08/13] drm: remove drm_fb_helper_modinit
To:     Christoph Hellwig <hch@lst.de>
Cc:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        live-patching@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 21, 2021 at 9:28 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Jan 21, 2021 at 09:25:40AM +0100, Daniel Vetter wrote:
> > On Thu, Jan 21, 2021 at 8:55 AM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > drm_fb_helper_modinit has a lot of boilerplate for what is not very
> > > simple functionality.  Just open code it in the only caller using
> > > IS_ENABLED and IS_MODULE.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> >
> > I didn't spot any dependencies with your series, should I just merge
> > this through drm trees? Or do you want an ack?
>
> I'd prefer an ACK - module_loaded() is only introduced earlier in this
> series.

I was looking for that but didn't find the hunk touching drm somehow ...

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
