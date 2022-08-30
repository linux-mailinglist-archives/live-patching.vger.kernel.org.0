Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1198B5A6CCD
	for <lists+live-patching@lfdr.de>; Tue, 30 Aug 2022 21:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiH3TJ1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Aug 2022 15:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiH3TJX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Aug 2022 15:09:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED1072FE0
        for <live-patching@vger.kernel.org>; Tue, 30 Aug 2022 12:09:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2D38B81D8E
        for <live-patching@vger.kernel.org>; Tue, 30 Aug 2022 19:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806E5C43470
        for <live-patching@vger.kernel.org>; Tue, 30 Aug 2022 19:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661886558;
        bh=Cmp8nm0gtpFMw8axS/cZOFt3L5lZb2ODTy3dpPtsjJ8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=l8lXDaWSzi+06ZPwgfz0G5a1WaR8o+eM3R6uWtUVJfiX4eRnHe2KEHgSRS/RgPHAB
         sIMAlE9W4K1PKvXd16WGwXumzuQD6iMKYEvbt35Dz2UaVbx+2zhPqnDrwNsMx4PyiT
         4a8LYXLEae4Huvn+8KP2CaiIb+PjZnDGK5LMgr6nNn44WssRxTgqsZHDvCMixhAVSv
         LQetWabURW6rBOj4upIUWC7NRUXeLG1e7+CEamSxIwqXQMvAb+X4Pcrgp+TYk4yKrX
         lgX2coqLdkMtGY1a3SxTiDc+uoNxzhGjKmf/MjR8v25+eCTh+iIFedVQTJOjtqfi6r
         KD+j2avJ4Hp2w==
Received: by mail-yb1-f178.google.com with SMTP id c9so962122ybf.5
        for <live-patching@vger.kernel.org>; Tue, 30 Aug 2022 12:09:18 -0700 (PDT)
X-Gm-Message-State: ACgBeo0T00Y/HPPr4ztxAsZk6TcAuBheXrWTc82QHMYPStNKmHbRXUjh
        nzAK0eB+VdqaRvQU66gz+d3FaVtmXwKChm32Yns=
X-Google-Smtp-Source: AA6agR4u8FQpVqonOizRjRP6apWE03IfPrNHddoSCXPdt4h8Rpagkkexqh3H+nI370Y1dY77ls0XZjqS3Y/53UkIrks=
X-Received: by 2002:a25:3f81:0:b0:696:4116:8ab9 with SMTP id
 m123-20020a253f81000000b0069641168ab9mr13074147yba.257.1661886557444; Tue, 30
 Aug 2022 12:09:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220802010857.3574103-1-song@kernel.org> <YumZDXVy+739tnps@redhat.com>
In-Reply-To: <YumZDXVy+739tnps@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 30 Aug 2022 12:09:06 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6xnSkr_g6ajTmi5gvksUQ-Yj+NBgwBkjD=YjEvSzVe6Q@mail.gmail.com>
Message-ID: <CAPhsuW6xnSkr_g6ajTmi5gvksUQ-Yj+NBgwBkjD=YjEvSzVe6Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] add sysfs entry "patched" for each klp_object
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Aug 2, 2022 at 2:37 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> On Mon, Aug 01, 2022 at 06:08:55PM -0700, Song Liu wrote:
> > I was debugging an issue that a livepatch appears to be attached, but
> > actually not. It turns out that there is a mismatch in module name
> > (abc-xyz vs. abc_xyz), klp_find_object_module failed to find the module.
> >
> > Changes v1 => v2:
> > 1. Add selftest. (Petr Mladek)
> > 2. Update documentation. (Petr Mladek)
> > 3. Use sysfs_emit. (Petr Mladek)
> >
> > Song Liu (2):
> >   livepatch: add sysfs entry "patched" for each klp_object
> >   selftests/livepatch: add sysfs test
> >
> >  .../ABI/testing/sysfs-kernel-livepatch        |  8 ++++
> >  kernel/livepatch/core.c                       | 18 +++++++++
> >  tools/testing/selftests/livepatch/Makefile    |  3 +-
> >  .../testing/selftests/livepatch/test-sysfs.sh | 40 +++++++++++++++++++
> >  4 files changed, 68 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/livepatch/test-sysfs.sh
> >
> > --
> > 2.30.2
> >
>
> For both,
>
> Reviewed-by: Joe Lawrence <joe.lawrence@redhat.com>

Hi folks,

Do we need more work for this set?

Thanks,
Song
