Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354024B0A1C
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 10:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239261AbiBJJ7d (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 04:59:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239251AbiBJJ7b (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 04:59:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 488B8BD3
        for <live-patching@vger.kernel.org>; Thu, 10 Feb 2022 01:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644487172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BfA2iFJwMibzGsqNn5V+xr5t8qyVpCn8grTyfArw+wQ=;
        b=CJZ3ejQb7iIqNoeE4tYLatiSIXbsZZkFEbLcN/QejqPYb3DjJsN4/lY2VxoPKCaGHEHtgU
        WL9w9U1UbkElLInEoACcValQT50V0wwiXe8tTVaxKuJ++BF0dW9VSf6Moignwdv1W6otjv
        gQTOCzTsJyOQbPpEzoogVovypLLebw4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-FKC41kkKOT2Lmi2k5BcgHg-1; Thu, 10 Feb 2022 04:59:31 -0500
X-MC-Unique: FKC41kkKOT2Lmi2k5BcgHg-1
Received: by mail-wm1-f72.google.com with SMTP id l20-20020a05600c1d1400b0035153bf34c3so4094275wms.2
        for <live-patching@vger.kernel.org>; Thu, 10 Feb 2022 01:59:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=BfA2iFJwMibzGsqNn5V+xr5t8qyVpCn8grTyfArw+wQ=;
        b=2nWiFSVH1Mx4VNLZrj2Va0ws2A4bV8h0zm26Pv7jcFYx4OtbeovahrpMS5fUfJwsRd
         vpGLS7TWOoolo3R7e5qJ//QjS5lVn1Ytqr0LIyfQy2zOEvRgz8sL10o0XXCnhWy3BVHE
         D2vVpU6H6YhJkF5RRqZnPtj3G9ESFz9LnhFfJ9LvqHOCB9/ooTLxz9hfRfyu37Z+iXA2
         GnS6AgHzkw6SKUwugMn7MIWEOoydEz8j/YNio5/jsI/bTt+lPNsXk3sUb23wQdT8Ti1L
         tGh2iZqzPPklHZbuw1dpQOIZzpxgUjmvywNIal5xejDhJIDKdFX23mUfc9KFBN33cfxh
         1DbQ==
X-Gm-Message-State: AOAM533gGMztEBWfsJYMzHbWrMVGlO+YbxrtSxSE5iN1qBr/5OWnvfP9
        fiqL1o0LcuHnck8TTEib+1CR3Tj94g3sm1uovgs3WPYxqMkhQyJWoM2R8+hO6lnBxpZU44ogCeK
        CraYb9Vty4w8elj/KFug7gFHr
X-Received: by 2002:a5d:5481:: with SMTP id h1mr5673414wrv.386.1644487166546;
        Thu, 10 Feb 2022 01:59:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBv2nKwftCzNCsKkaPwuBvX4on6VNzrk0X7Gfq2MKiJkchFNnOAzOMhkypUYzMlfiwR/kKrA==
X-Received: by 2002:a5d:5481:: with SMTP id h1mr5673395wrv.386.1644487166349;
        Thu, 10 Feb 2022 01:59:26 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id h17sm990687wmm.15.2022.02.10.01.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 01:59:25 -0800 (PST)
Date:   Thu, 10 Feb 2022 09:59:25 +0000
From:   Aaron Tomlin <atomlin@redhat.com>
To:     Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Cc:     20220209170358.3266629-1-atomlin@redhat.com, mcgrof@kernel.org,
        cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com, christophe.leroy@csgroup.eu,
        oleksandr@natalenko.name
Subject: Re: [PATCH v5 07/13] module: Move extra signature support out of
 core code
Message-ID: <20220210095925.qa2wk5ec6e5vlkvl@ava.usersys.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
References: <20220209170814.3268487-1-atomlin@redhat.com>
 <20220209204812.GD3113@kunlun.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220209204812.GD3113@kunlun.suse.cz>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-02-09 21:48 +0100, Michal Suchánek wrote:
> This reverts a97ac8cb24a3c3ad74794adb83717ef1605d1b47

Hi Michal,

Oops! I'll address this.


Thanks,

-- 
Aaron Tomlin

