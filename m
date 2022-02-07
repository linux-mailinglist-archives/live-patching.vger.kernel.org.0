Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DFF4AC83F
	for <lists+live-patching@lfdr.de>; Mon,  7 Feb 2022 19:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiBGSI5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 7 Feb 2022 13:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353848AbiBGSBx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 7 Feb 2022 13:01:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 180A2C0401E6
        for <live-patching@vger.kernel.org>; Mon,  7 Feb 2022 10:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644256912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ZC9voboJMLyP9X+M4c3BNIBV745SBUEBDiANYpctyI=;
        b=FemED7jx0deNUbjqxYPdnoYpM+lROLfNU6iy2ihZyucIHU0t4GoZcY0edO/y4SB+6vwzqb
        R01pBf1QbL3HNT/ebwvHaAdEScquGd3XpRz2z8K0UNuCtMgwY854f9M2mISbL9xLxq2/TE
        nd23zKn+OBws8n0i1EHTaAI4zXdb2pc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-9GEwTewHNZ2MXjQ1pPk4tQ-1; Mon, 07 Feb 2022 13:01:51 -0500
X-MC-Unique: 9GEwTewHNZ2MXjQ1pPk4tQ-1
Received: by mail-wm1-f72.google.com with SMTP id n3-20020a05600c294300b0037bc685b717so1858891wmd.8
        for <live-patching@vger.kernel.org>; Mon, 07 Feb 2022 10:01:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7ZC9voboJMLyP9X+M4c3BNIBV745SBUEBDiANYpctyI=;
        b=ynWgu2LI+q8h9SkFwdsIoPEK5VxNTxHvBCiflO9LKWjgzHcRuhNpg2lk9ciQZaVHfU
         fhIjVPjZ4cDBXyiQT2PrYU5NiWu/GD/1G8IJKdbJYzq4498gvxGfwM2qOsRLU4QyyPzW
         IxseTLPIOTqb5o+s2cJQjPcUdA2So4rcyJF55lGp7qAH5PvIdodBa6RFSqG4bE70dlci
         bMeATYhFOuCtf2zUcDbx0V7cKq370KmVGPtrIejrxoaR99prx89Ffenhy8az+ZHund9g
         Z+Ws3vj4bgjJYCL20/bh/s7q20zjos4Vb+OHEdsaqcKqmz9OC9XikTMGZ8I6ro8KuEtV
         wbKg==
X-Gm-Message-State: AOAM532cFUGivu0I9S5J8fK3tmy6/aRnBV4ln/CV9T/YjoSsoLQV6UeI
        WJWeXa57zMYqA2pQDonKOfVKlJw2Ss7KRJr5WHOXjOJsqFaf0Vy+fTeWXFzjHn4oPBg2Js4Zyio
        ZG+tSoXp/iF/c5M8qUA/S8sMy
X-Received: by 2002:a05:600c:35c5:: with SMTP id r5mr52354wmq.195.1644256910055;
        Mon, 07 Feb 2022 10:01:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwHGKUD5R67kKE3OayMIvijga96fYqhI4O3QezVsa05W/PCwK6GX5Iiq/+FauG4WL4qC8Qivg==
X-Received: by 2002:a05:600c:35c5:: with SMTP id r5mr52327wmq.195.1644256909789;
        Mon, 07 Feb 2022 10:01:49 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id g20sm68731wmq.9.2022.02.07.10.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 10:01:49 -0800 (PST)
Date:   Mon, 7 Feb 2022 18:01:48 +0000
From:   Aaron Tomlin <atomlin@redhat.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Aaron Tomlin <atomlin@atomlin.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Michal Suchanek <msuchanek@suse.de>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "void@manifault.com" <void@manifault.com>,
        "joe@perches.com" <joe@perches.com>
Subject: Re: [RFC PATCH v4 00/13] module: core code clean up
Message-ID: <20220207180148.bbstggd4yr5ozfrf@ava.usersys.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <Yfsf2SGELhQ71Ovo@bombadil.infradead.org>
 <1ae3a950-8c1e-a212-e557-8f112a16457d@csgroup.eu>
 <20220207164659.ap42at2nphxu4q6o@ava.usersys.com>
 <b0a54f00-b9ac-df55-e8d2-d3eb95039a95@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b0a54f00-b9ac-df55-e8d2-d3eb95039a95@csgroup.eu>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-02-07 17:17 +0000, Christophe Leroy wrote:
> Yes and that's the purpose of the patch I proposed at 
> https://patchwork.kernel.org/project/linux-modules/patch/203348805c9ac9851d8939d15cb9802ef047b5e2.1643919758.git.christophe.leroy@csgroup.eu/

I see.

> Allthough I need to find out what's the problem reported by the robot.

I'll have a look too.

> As suggested by Luis, this fix should go once all ongoing work is done. 
> But it would be nice if you could just remove patch 5 from you series, 
> otherwise we would have to revert it later.

Perhaps it might be easier if I keep the patch within the series; once
merged into module-next, by Luis, you can rebase and then add the "Fixes:"
tag to resolve the issue, no?


Kind regards,

-- 
Aaron Tomlin

