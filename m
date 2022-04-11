Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961A14FC279
	for <lists+live-patching@lfdr.de>; Mon, 11 Apr 2022 18:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237676AbiDKQhI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 11 Apr 2022 12:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiDKQhH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 11 Apr 2022 12:37:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A74321115F
        for <live-patching@vger.kernel.org>; Mon, 11 Apr 2022 09:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649694892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MuDooJV2r3lRDseKl98XLYOZNZXFlgTW6Icouk1a/rA=;
        b=dL7kvYl5T9F9Kp8ypeXoacJ8+eJKuHoKjjMHZ4AhxJi4T7pQDlYz5wY7BZgLFnEH0iaXK8
        Jdc/CwUC0bX1p8M9rOGPbj+5ukJO5C50I0o8p8TX1NIRiynLhvyuR2MpKJSNpiqLABweu7
        927NxFrzfcBb9L0AAE9zGD3br+ylc8s=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-73QdCH8FOq6eyy70emU6fA-1; Mon, 11 Apr 2022 12:34:51 -0400
X-MC-Unique: 73QdCH8FOq6eyy70emU6fA-1
Received: by mail-qt1-f200.google.com with SMTP id z3-20020ac86b83000000b002ed0f18c23cso4891909qts.17
        for <live-patching@vger.kernel.org>; Mon, 11 Apr 2022 09:34:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MuDooJV2r3lRDseKl98XLYOZNZXFlgTW6Icouk1a/rA=;
        b=YhECkiKfpu2PRl+qSkzmWxJkRF0xPH0t4nwrCjCB5aKoE2SDRauM/pjTuWNQAG7Xl0
         ckoK/tM6eX+GkpZ3+HGVEn6sHO+UUM6m8qQjgK+VLYUFfJiG5/t5SbfIaBmIljyOknXd
         yjw/Zly5lmef5wqMbYF/Sb4CRqrsHOWJy+OgKcTjQlfo8dP2q5gEnKApS9nZoSQ7hx8K
         DZ7b5PzeHmTMvP8tyYDZjEZC43CT3DQsYXxje/5b9IHpUDs1XxV4zfQSDjvGMJ3WXfEB
         ncEFu5gyDIhZ55FCSOjkCsRxhzfPdX8szjS34vAmVEGfNOnk+KzK5HQjw5WMtjEuE970
         rVbQ==
X-Gm-Message-State: AOAM53142AOsoVkLZgn+rG0WaWf+p8XeqXSZLHlhskR5rnyNFK/bneWK
        vdeXEecPrCEv2AHmhXcIueGSvxaDHowV++qylpa3bGsjC1dpco6N65crpo3yxBDZBvzSTtahpMM
        X5LCv0ie68Y54mdOxlUKMswOi8w==
X-Received: by 2002:a05:620a:4450:b0:69c:11f3:d3c9 with SMTP id w16-20020a05620a445000b0069c11f3d3c9mr160676qkp.378.1649694891174;
        Mon, 11 Apr 2022 09:34:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhubFLyDLek8KqhligvLIzm/0FG1M86oPwUSg1Uvoy1ilxqbTHCbbp3j0wcBH5MrzHOcEn1A==
X-Received: by 2002:a05:620a:4450:b0:69c:11f3:d3c9 with SMTP id w16-20020a05620a445000b0069c11f3d3c9mr160653qkp.378.1649694890930;
        Mon, 11 Apr 2022 09:34:50 -0700 (PDT)
Received: from treble ([2600:1700:6e32:6c00::15])
        by smtp.gmail.com with ESMTPSA id i184-20020a37b8c1000000b00699fa585088sm9289956qkf.46.2022.04.11.09.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 09:34:50 -0700 (PDT)
Date:   Mon, 11 Apr 2022 09:34:46 -0700
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, mark.rutland@arm.com,
        broonie@kernel.org, ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Message-ID: <20220411163446.o3el6pxxsla2564a@treble>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <YlAUj6w6fePEo7v+@hirez.programming.kicks-ass.net>
 <93b08ed3-80ca-4171-aaed-1513ae7cb0e1@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <93b08ed3-80ca-4171-aaed-1513ae7cb0e1@linux.microsoft.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun, Apr 10, 2022 at 12:47:46PM -0500, Madhavan T. Venkataraman wrote:
> 
> 
> On 4/8/22 05:55, Peter Zijlstra wrote:
> > On Thu, Apr 07, 2022 at 03:25:09PM -0500, madvenka@linux.microsoft.com wrote:
> > 
> >> [-- application/octet-stream is unsupported (use 'v' to view this part) --]
> > 
> > Your emails are unreadable :-(
> 
> I am not sure why the emails are unreadable. Any suggestions? Should I resend? Please let me know.
> Sorry about this.

That was actually my (company's) fault when I bounced the patches to Peter.

-- 
Josh

