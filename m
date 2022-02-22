Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC694BF71B
	for <lists+live-patching@lfdr.de>; Tue, 22 Feb 2022 12:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiBVLTM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 22 Feb 2022 06:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiBVLTL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 22 Feb 2022 06:19:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F20F3108779
        for <live-patching@vger.kernel.org>; Tue, 22 Feb 2022 03:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645528725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A2gckBtnixMVaahVtnNibGnabKhb0jcedbRGPNNAXj0=;
        b=YQNUO0erd2QUKYfR/AbHaCec38fv2MvrXL9NyGsZ5/82YTC2MaN4IgtzSMiB9Yge8qgNat
        Ur8BG5GNECbfZc3MdfXA61qVvtnA+TEEtaRL5sLC7rnGBm3uuhWoalzAsEVcCulJC7K2Ok
        JaIvIvoOu7TLAekXNuCLYv2BYoYyTew=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-X9Wdgt_pM7GN3WN10fe3mA-1; Tue, 22 Feb 2022 06:18:44 -0500
X-MC-Unique: X9Wdgt_pM7GN3WN10fe3mA-1
Received: by mail-lj1-f200.google.com with SMTP id r27-20020a2e575b000000b002463f43ca0aso2951069ljd.7
        for <live-patching@vger.kernel.org>; Tue, 22 Feb 2022 03:18:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A2gckBtnixMVaahVtnNibGnabKhb0jcedbRGPNNAXj0=;
        b=X9JpYc1N/DwEl+Dcz84+zNFkcvrwWOFmYZ6gJCJc58bprcLD/5/sMNdeG+oySY+Lxw
         uh5baGEun6bdHA08oPL6EM7tHc2Vo+p3XQC17oS7+jCEQ7D6OYHbFlz8QhlC6jsNv39Q
         1A7+OU230goWFy0SBMiFUFx/GPcI9Gsxkw2UhgAcx2Al98u6V2jQG5CdZb52hpRzVA6c
         jrTSU8z08AvyXHDYW/2ud330ktbjUyXF1YhFVjy+mEJkveipBR5krFexiyxvujNwvFwV
         yxg/N3CHDB6tL/X251Y3eKNRliVekinpUsvx6JyYryKuc33evmWgD/YDtt3SLBRnn2TB
         +6Ww==
X-Gm-Message-State: AOAM532/gvi1g6J4z6AZpEDdy8/gJGh8f8kumokWLgBe6rqjU6sgRUKg
        1L+4fBUo1IaOhRMJHohnQquU7y6/Sb9/vZMHYgmBURCQmNvCPQT43/wGMv739DoqmvlLHBEh4Ht
        ecHJL8Jh3B+1yMcLBEGXVZbMZa45NMX9HVBUHChtQ
X-Received: by 2002:ac2:5cd0:0:b0:443:b112:e512 with SMTP id f16-20020ac25cd0000000b00443b112e512mr14638288lfq.118.1645528722353;
        Tue, 22 Feb 2022 03:18:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyfIlZqtjd+JGObGg/qk7CWDZ/9xEu4n9eTUbEhI/8LWxeCG+1eUeDp/NcygYU0N+2juzdpOKkYm0z34f9B6/A=
X-Received: by 2002:ac2:5cd0:0:b0:443:b112:e512 with SMTP id
 f16-20020ac25cd0000000b00443b112e512mr14638272lfq.118.1645528722101; Tue, 22
 Feb 2022 03:18:42 -0800 (PST)
MIME-Version: 1.0
References: <20220218212511.887059-1-atomlin@redhat.com> <YhBSBzmuiDQ4yMER@bombadil.infradead.org>
In-Reply-To: <YhBSBzmuiDQ4yMER@bombadil.infradead.org>
From:   Aaron Tomlin <atomlin@redhat.com>
Date:   Tue, 22 Feb 2022 11:18:30 +0000
Message-ID: <CANfR36jqAk2DMxVOawYZfAz-BL-g-Dxj=x-mOes3wqnukz+VAg@mail.gmail.com>
Subject: Re: [PATCH v6 00/13] module: core code clean up
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     "Lameter, Christoph" <cl@linux.com>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, jeyu@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        Aaron Tomlin <atomlin@atomlin.com>,
        Grzegorz Halat <ghalat@redhat.com>,
        Allen <allen.lkml@gmail.com>, Joe Perches <joe@perches.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michal Suchanek <msuchanek@suse.de>, oleksandr@natalenko.name
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-02-18 18:12 -0800, Luis Chamberlain wrote:
> On Fri, Feb 18, 2022 at 09:24:58PM +0000, Aaron Tomlin wrote:
> > Hi Luis,
> >
> > As per your suggestion [1], this is an attempt to refactor and split
> > optional code out of core module support code into separate components.
> > This version is based on Linus' commit 7993e65fdd0f ("Merge tag
> > 'mtd/fixes-for-5.17-rc5' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux").
> > Please let me know your thoughts.
>
> Fantastic, thanks for doing all this work, I've pushed this out to
> modules-next so that the testing can start as this will be in linux-next
> soon. I'll obviously wait for more reviews, we have a long time before this
> gets merged to Linus, so just want to start getting testing done now rather
> than later. And other folks are depending on your changes to start
> getting their own code up too.

Hi Luis,

No problem. Unfortunately, this was not the complete series. I can send a
v7 later today with the suggested improvements made by Christophe.


Kind regards,

-- 
Aaron Tomlin

