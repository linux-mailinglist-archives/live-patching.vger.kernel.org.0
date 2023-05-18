Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1D2707CD3
	for <lists+live-patching@lfdr.de>; Thu, 18 May 2023 11:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjERJ3R (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 May 2023 05:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjERJ3P (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 May 2023 05:29:15 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82705211E
        for <live-patching@vger.kernel.org>; Thu, 18 May 2023 02:29:13 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9659c5b14d8so280312366b.3
        for <live-patching@vger.kernel.org>; Thu, 18 May 2023 02:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684402152; x=1686994152;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zYlqmqzmZQIzuckqyml+D+cUQfB/LAmhyfGQVjeCZAE=;
        b=a3QvnZICXfFPq3JkWW+ZciVex9z2eC5AHCM4c5oDS2p5cH1vwZ5EHcRPqRUORqnL1y
         r0IAsNaWHbjG/nzxp3xgBuOr8JhwrMU/DXaunWiQIuYUtw3zBFLtFIKHxm0frzpRiXQK
         u6etOUJTK9DoI9sHGcDk8jNyOGeq+tH0IqGQ9vl6E0bTYH5F4hiMyAgtcLDx5HyAMaw4
         KTXiOTeTkj4KPzAvWAX+P6AV9Bl7Mdra6C1YIJkUxZoKFPNtL1xwFqvFhQIb8YYZHBGc
         IxH5F132QApG9z5ndCPviue9R8aBX06GdX92E/v5nnHPP3nU5Y+mLGQIh3yPTFAihwDh
         XYxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684402152; x=1686994152;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zYlqmqzmZQIzuckqyml+D+cUQfB/LAmhyfGQVjeCZAE=;
        b=HZugThPkkly4ZLrAGSjrnb63IKKM4SQ/mhzjp6xQFhoIQwEX8JOsfvmCWtFR4UXFRz
         rBmhhU/j+thddwAeXrz4IpEuKaHnG7JBwEEiopuggMJ8ChZvpaHWq6lL01WlyvkHgDTU
         IMP++LM+OC2/e80+wJ60RrSalq/UVy2AGBFJgYHAqzSh8U+COgKFavagQe2Zq6ACzCnz
         z+YRf//C9U+7BAFQ84WLz22guOPqwnBfE6z81mK91+ytcCfa6Y11+T/5Lusn9uHHd53c
         VQrPJGIy1eQdDjb9cqoFDZoRDpuf12SlSXsgtCdpLaXDvRpdwDUxQnrKO2GthoKmmU5q
         GG6w==
X-Gm-Message-State: AC+VfDylr6tKYOkAOX5wK0lGu4om6lw2S787E+HEmPZGKdjCcGM6koef
        iR2bnCViNnW0IrMGuT1DvPP22cY97B1iIcmlXEY=
X-Google-Smtp-Source: ACHHUZ78F0LGaq8DequUjO+fCXm4nXkRiBCrawNnftppC4CWljscYqcwF/vzJg7AgiOtuonEGE/gbtI9Wr5wqy2Y4Mo=
X-Received: by 2002:a17:907:8694:b0:96a:1c2a:5a38 with SMTP id
 qa20-20020a170907869400b0096a1c2a5a38mr28432014ejc.11.1684402151761; Thu, 18
 May 2023 02:29:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:dace:b0:94a:7e28:ef2d with HTTP; Thu, 18 May 2023
 02:29:10 -0700 (PDT)
Reply-To: ninacoulibaly03@myself.com
From:   nina coulibaly <ninacoulibaly013@gmail.com>
Date:   Thu, 18 May 2023 02:29:10 -0700
Message-ID: <CAHS6EwVXdRLR22i_98eq2aDoBpn8YnjDVH6YqypTttGfrdpnRg@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Dear,

Please grant me permission to share a very crucial discussion with
you. I am looking forward to hearing from you at your earliest
convenience.

Mrs. Nina Coulibaly
