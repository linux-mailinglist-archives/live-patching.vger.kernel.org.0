Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDF94AB000
	for <lists+live-patching@lfdr.de>; Sun,  6 Feb 2022 15:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242989AbiBFOm3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 6 Feb 2022 09:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242953AbiBFOm2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 6 Feb 2022 09:42:28 -0500
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 06:42:07 PST
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84F32C043183
        for <live-patching@vger.kernel.org>; Sun,  6 Feb 2022 06:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644158526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3xo75bD0PDOaBPfVsPyq+FCl95QCjNPeMKREfcTC2z4=;
        b=R+ERPZcigu1+ComU8sH+0RQoWK6MQGWsq9/uM4EkiiUGw6O5vLd1qiqQe1xC5BITQ3flnt
        k5GWj4HjXu43GQTXiAUNpGA81ykJtVcak2Bi2EKA+/2gPjEK6CnTGQ+AqpY3tO8ZqVouHK
        xI+7ZM+xmNW+yASgfbOMTQrz8DYVuYU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-mb-9TGyMNcWMikOq8t4pIQ-1; Sun, 06 Feb 2022 09:41:00 -0500
X-MC-Unique: mb-9TGyMNcWMikOq8t4pIQ-1
Received: by mail-wm1-f69.google.com with SMTP id z2-20020a05600c220200b0034d2eb95f27so4301491wml.1
        for <live-patching@vger.kernel.org>; Sun, 06 Feb 2022 06:41:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3xo75bD0PDOaBPfVsPyq+FCl95QCjNPeMKREfcTC2z4=;
        b=0uHW6vtK9fFOhDmudr9eAo//whn+OmRQWIoenKkJ7j40XRGKk0G4rNDhhbRLYGjwCe
         xEbqG7r6ScAGYDS3wF6/Wi02CGtlzwZeDvjjyTICV2GC9P/TWdasNYc9ZqVVRPm6Shwp
         G6/C2GWv68XxM0IUr5lWrMkeETTHL+B0fGQd8S3n8lXVIglX4wkDzwOocCXD9adjuBmM
         6w1Klhv0ACN+pK76nJZ9bQQT6+uwKrjNnUsH/ybpViLtjK0+ZpJ7JYcfQEak0NJS5Ut+
         Q/VKGY8DqBa1epOtT7jcXXcq5m5vg8O54D0tmR+vImNbsMLYC5VgwgsxI+jcfgbSA3i8
         KzTg==
X-Gm-Message-State: AOAM530IGTX2Kd4SUH5/bDerKyFMbxn3TO7oLwz4d7si1qHhoppzP3JZ
        jjHm2oUYPxVi2x7H32SL4Nh7QbcsHHCpctGTG406bKTrwzbHtmM7+ydSzVBX2jc/HAvmBqz9SjE
        vLaf+XBClMmN/If9/DWzjMwLE
X-Received: by 2002:a1c:6a11:: with SMTP id f17mr7307814wmc.183.1644158459547;
        Sun, 06 Feb 2022 06:40:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzm/kRptajKDTAh89yC1ciHnNdlI1yp9Czrsc5eMbNPyYfBFvivYGaNPSqesEaBuIRdpJvwwA==
X-Received: by 2002:a1c:6a11:: with SMTP id f17mr7307795wmc.183.1644158459401;
        Sun, 06 Feb 2022 06:40:59 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id p15sm834616wma.27.2022.02.06.06.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 06:40:58 -0800 (PST)
Date:   Sun, 6 Feb 2022 14:40:57 +0000
From:   Aaron Tomlin <atomlin@redhat.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: Re: [RFC PATCH v4 00/13] module: core code clean up
Message-ID: <20220206144057.sp4ldrxq2eqp5g4k@ava.usersys.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <YfnwB0GkXln4KaGk@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfnwB0GkXln4KaGk@bombadil.infradead.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-02-01 18:44 -0800, Luis Chamberlain wrote:
> Nice, can you get this tested with 0day? You can ask for your tree to
> be tested, see:
> 
> https://01.org/lkp/documentation/0-day-test-service
> 
> See the question, "Which git tree and which mailing list will be tested?
> How can I opt-in or opt-out from it?"

Thanks for this information Luis.



Kind regards,

-- 
Aaron Tomlin

