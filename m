Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014744AB0CA
	for <lists+live-patching@lfdr.de>; Sun,  6 Feb 2022 18:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbiBFRAU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 6 Feb 2022 12:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343505AbiBFRAQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 6 Feb 2022 12:00:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A66E0C06173B
        for <live-patching@vger.kernel.org>; Sun,  6 Feb 2022 09:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644166814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gr+rlvFHZLc88iZxU30W/q3Yu4fbVb5uGtYcLcCB13U=;
        b=Psqs9DDO18PKaVq5PQ9BDoThiY3YY7gkfa7k0eVSL4r+Lf6AuUZOyOy0ajOIJJdDaZj0LJ
        iYjLGeYxDtTaYk0PofYruc5QTwo92TKj9+y1ibYYFw/kE5GSz/6PrafD6CImz5hM4VoH9P
        T0/77AnbcR5hJb8hbRgym8WikQlZpXA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-UPKVaOB1OFiDNENCj6CW-Q-1; Sun, 06 Feb 2022 12:00:11 -0500
X-MC-Unique: UPKVaOB1OFiDNENCj6CW-Q-1
Received: by mail-wm1-f69.google.com with SMTP id r205-20020a1c44d6000000b0037bb51b549aso2349838wma.4
        for <live-patching@vger.kernel.org>; Sun, 06 Feb 2022 09:00:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gr+rlvFHZLc88iZxU30W/q3Yu4fbVb5uGtYcLcCB13U=;
        b=Di8cQToBYYobTlYYP+JND7yEpFpbBmzJMWuecWHiOhK3IQGuJRtwUf03adMYXbEPsD
         4T1tTc159tKfWX8+YIeYbfNFBVBAP+AtsQQVH892GvxFYHth9e1ATnMvrOVupt2LdAMr
         DDIz/ioYAzH6plOr7JqkxIfV7xWa/Rm+egh5TxCO4t8c+Qix+oL9xt9AyPMBXRf9+z4X
         zQO3wza6M1knvGdsT/DDVyuRHDpoRH9+V7otNyYkpRHe7VOVzMi1JHZplkg+9jxdBF67
         quQkufVUDO81GWRjNB65niSc6nnEQbPDSvu3BKu++AcsMeXnXZcmtIFvVCpNTvtC0AAs
         /4Kw==
X-Gm-Message-State: AOAM531x0NNQhVlzEsNrRHYCj3P3arTRzmQWZyy8hDnKSranjX7xcgeY
        aDD8WWrpePr20ai1uMHN43n4TBgLNDWhqezdk1Vn78ex4Wnx3K0zsK6xPIkmf54uHSFV5VtQomm
        Fwrq4TwLJj0x1Vns1lvP/i7z2
X-Received: by 2002:a05:6000:258:: with SMTP id m24mr7120745wrz.2.1644166810626;
        Sun, 06 Feb 2022 09:00:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvmFZ6FmoMqKj+jRzNF88xYXp8uy84SvUPF3XkmfOUrST3yD/G26iHFSaMCzsUFgWkG8uaVw==
X-Received: by 2002:a05:6000:258:: with SMTP id m24mr7120721wrz.2.1644166810387;
        Sun, 06 Feb 2022 09:00:10 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id b10sm4980698wrd.8.2022.02.06.09.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 09:00:09 -0800 (PST)
Date:   Sun, 6 Feb 2022 17:00:09 +0000
From:   Aaron Tomlin <atomlin@redhat.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michal Suchanek <msuchanek@suse.de>, cl@linux.com,
        pmladek@suse.com, mbenes@suse.cz, akpm@linux-foundation.org,
        jeyu@kernel.org, linux-kernel@vger.kernel.org,
        linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        atomlin@atomlin.com, ghalat@redhat.com, allen.lkml@gmail.com,
        void@manifault.com, joe@perches.com
Subject: Re: [RFC PATCH v4 00/13] module: core code clean up
Message-ID: <20220206170009.exz5slme7drxqyoa@ava.usersys.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <Yfsf2SGELhQ71Ovo@bombadil.infradead.org>
 <Yfw2nm5X+8jRic0C@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yfw2nm5X+8jRic0C@bombadil.infradead.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-02-03 12:10 -0800, Luis Chamberlain wrote:
> Linus now merged the fix in question, just be sure to use his
> latest tree, it should include 67d6212afda218d564890d1674bab28e8612170f

Hi Luis,

Sure, will do.

> If you can fix the issues from your patches which Christophe mentioned
> that would be great. Then I'll apply then and then Christophe can work
> off of that.

All right. I will try to complete this shortly.


Kind regards,

-- 
Aaron Tomlin

