Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06684B276D
	for <lists+live-patching@lfdr.de>; Fri, 11 Feb 2022 14:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350655AbiBKNvw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 11 Feb 2022 08:51:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbiBKNvv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 11 Feb 2022 08:51:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAEC9EB
        for <live-patching@vger.kernel.org>; Fri, 11 Feb 2022 05:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644587510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RVg5C30Oj6ty7sDy10JOxyHHGxYzU297SK2Orj9qUYs=;
        b=czUqAnBN8VYkist3TEW22x5LrF5SBjYQvJ9BOpPJopDcZOX1uhAPwaLlaS5fKvpOND4Tyc
        TEfneL/BV3YE8iddWWC7u+bf/zmSpFQIK2+3LRg52LzZBs2rK303FHYKwK3qp58TaGhLz5
        LtecM7VLsDa2uWYiB/l3qpsBtwFUCRU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-RbolQ2_qMhmPkuI6j1N6yg-1; Fri, 11 Feb 2022 08:51:48 -0500
X-MC-Unique: RbolQ2_qMhmPkuI6j1N6yg-1
Received: by mail-lj1-f197.google.com with SMTP id b35-20020a2ebc23000000b002447143a325so4040847ljf.11
        for <live-patching@vger.kernel.org>; Fri, 11 Feb 2022 05:51:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RVg5C30Oj6ty7sDy10JOxyHHGxYzU297SK2Orj9qUYs=;
        b=D1pkhYeUOLnatpKBWy/U90tfNfzp6EBCKrGDQO1JeZCldnMrXXkscfSE4G+bJ+lJp6
         fAStDsnINtIurSVVLzWJRzlF2ltllaBYXuQ4Mlm0MXr22UlllEyCHU9dEFD51oyuvid+
         dXSvJMwodcJ6Axk08/laHJR5zogQSdk6v7FnWGJkyBz/NN+TdRXJJbKacnWiPgMNlAwU
         kKA1//+HVLmR38FSttu3Pceo4xEl7W3Y9JkumGqSCoNJEdT2fExBwEhsbbN7tOm9hvjS
         lrhWPoltx5F4a/mUt5Fo/LknHdYHEn3cANqtAtH1lzFfwEeuy6BidgWOobTFsylCc8bs
         VNMQ==
X-Gm-Message-State: AOAM5327MB/uy6Zin67wIK8zpCSdNiHtfajpQzXFeO31p0rXmASMkfbP
        jvOgYAQvsJPvOqSy4tjnjDQJKp/M3cGIz2G48iRZNEC3H5vVeUMSo8rwKa+6QSPbGxtpAgQCasM
        HGVGmOVIRbv63cdIGs9LTkC/oJ7xH6ntsOZFOJU1k
X-Received: by 2002:a2e:7311:: with SMTP id o17mr1072574ljc.303.1644587507236;
        Fri, 11 Feb 2022 05:51:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzxYYIQ7iaZgj9t/ZkVJp2mKf0LBRcoXCaVyjq0xBb6DehIRF94SGL/fyH56gx3Xj0+ahH/2wW7s0aHY1BVMqs=
X-Received: by 2002:a2e:7311:: with SMTP id o17mr1072568ljc.303.1644587507053;
 Fri, 11 Feb 2022 05:51:47 -0800 (PST)
MIME-Version: 1.0
References: <20220209170814.3268487-1-atomlin@redhat.com> <8b7988be-488e-f570-b499-5892c57f5e04@csgroup.eu>
In-Reply-To: <8b7988be-488e-f570-b499-5892c57f5e04@csgroup.eu>
From:   Aaron Tomlin <atomlin@redhat.com>
Date:   Fri, 11 Feb 2022 13:51:35 +0000
Message-ID: <CANfR36i7fny7_z1j6bVAnzxVpxTXPQYTrZ-NoSTs63K-YuvNWg@mail.gmail.com>
Subject: Re: [PATCH v5 07/13] module: Move extra signature support out of core code
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "20220209170358.3266629-1-atomlin@redhat.com" 
        <20220209170358.3266629-1-atomlin@redhat.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "void@manifault.com" <void@manifault.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-02-10 13:01 +0000, Christophe Leroy wrote:
> Why do patches 7 to 13 have a Reply-to:
> 20220209170358.3266629-1-atomlin@redhat.com and not patches 1 to 6 ?

Christophe,

Please disregard this mishap. Unfortunately, at the time I hit the relay
quota.

> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index fd6161d78127..aea0ffd94a41 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -863,6 +863,7 @@ static inline bool module_sig_ok(struct module *module)
> >   {
> >       return true;
> >   }
> > +#define sig_enforce false
> sig_enforce is used only in signing.c so it should be defined there
> exclusively.

Agreed.

> And checkpatch is not happy:
>
> CHECK: Please use a blank line after function/struct/union/enum declarations
> #27: FILE: include/linux/module.h:866:
>   }
> +#define sig_enforce false

Ok.


Kind regards,

-- 
Aaron Tomlin

