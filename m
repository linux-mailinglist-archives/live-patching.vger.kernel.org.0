Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057B44B12AD
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 17:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238131AbiBJQ0l (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 11:26:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244178AbiBJQ0k (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 11:26:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9FF5D44
        for <live-patching@vger.kernel.org>; Thu, 10 Feb 2022 08:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644510400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rY3phGFyqzvqC5XqBvgZRHwWvJirMd+irMKZuvfo6EI=;
        b=MY5TpNx97fcJ3wiV/4Ov1NVh+PgOh8buMoGlUNCBSYSBXOWsSQMpDGEFC0GCZJvKBmDjo2
        FHgRh/EaiIXioo6yP03EAFQ+AHa+CQNb5WAiVUl8npEWej39ifd2OxV352VUyWO2ntpZE9
        ZMQvkjugiJucKsB5SJZlDHrMETWQ51s=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-q163EcauN1uLMj6xchF7Xw-1; Thu, 10 Feb 2022 11:26:39 -0500
X-MC-Unique: q163EcauN1uLMj6xchF7Xw-1
Received: by mail-lj1-f200.google.com with SMTP id w4-20020a05651c102400b0023d50aba238so2791708ljm.22
        for <live-patching@vger.kernel.org>; Thu, 10 Feb 2022 08:26:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rY3phGFyqzvqC5XqBvgZRHwWvJirMd+irMKZuvfo6EI=;
        b=FRvbFhTqfwi61elwlh6wvQLi8YOtPFDHM65QINFLi6DgAci4rF4FxzhCddMkmt7fy/
         dbUKneU6zot2RIY92n+CnEcaTL2LuN+X5bSKSDJjNbJxientd36kJ6YAYyHTnugWWAFI
         23hh403Oohj5u8Rw9O34Se4WxerpphjsZYHp0JTtaOL93DDtt/pqF/X0SinxQQccVczg
         UYbwGhdppKQYDCIV5RGttmFIl8zIhgMtSyAZevJsCkHpc17LH3YQLhDH0H5S2vgdjCNs
         w9mWkyTt7W2X4q5uAgjkA7behW7NV+mJhVy1/TmBJ7nd4ldqigVOLLSqltaiGRFPTAlX
         G/Eg==
X-Gm-Message-State: AOAM532KNd1GnVnXcmm6QhWt0td17rm7ok+3jsdQCXcr1kTh1Lo0pbDL
        ethkUKPapyxVqVcj8KsERBksrLodsWn/x5/jm7T3pPdLDyTFv/axyCfqstApn2J0xvOOUmjMQYC
        oZyPvm2hb8HNpUiEsr+ld99fQiZzs0Fj2jq0idjrs
X-Received: by 2002:a2e:9b42:: with SMTP id o2mr5338851ljj.85.1644510397698;
        Thu, 10 Feb 2022 08:26:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw9JIlgHvIwzA75M+U5BYw5VLOvJhfEKK89UxctqRfc/hcGRqbB7269Gq1HJ/earlGgnR33FLSJpEfMa8PkcNk=
X-Received: by 2002:a2e:9b42:: with SMTP id o2mr5338822ljj.85.1644510397492;
 Thu, 10 Feb 2022 08:26:37 -0800 (PST)
MIME-Version: 1.0
References: <20220209170358.3266629-1-atomlin@redhat.com> <20220209170358.3266629-3-atomlin@redhat.com>
 <f40fd2b2-2038-a53b-23ec-8f63941a2103@csgroup.eu>
In-Reply-To: <f40fd2b2-2038-a53b-23ec-8f63941a2103@csgroup.eu>
From:   Aaron Tomlin <atomlin@redhat.com>
Date:   Thu, 10 Feb 2022 16:26:26 +0000
Message-ID: <CANfR36jWjL9c1p8huGR8mh=XWXoNEc=Y8SmwXFCusEQ6CbuKmA@mail.gmail.com>
Subject: Re: [PATCH v5 02/13] module: Simple refactor in preparation for split
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "mcgrof@kernel.org" <mcgrof@kernel.org>,
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-02-10 11:18 +0000, Christophe Leroy wrote:
> > +#define MODULE_SECT_READ_SIZE (3 /* "0x", "\n" */ + (BITS_PER_LONG / 4))
>
> This is used only in sysfs.c, why move it to internal.h ?

Agreed. Since use is exclusive to kernel/module/sysfs.c it should be moved.

Kind regards,

-- 
Aaron Tomlin

