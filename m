Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222B57096B8
	for <lists+live-patching@lfdr.de>; Fri, 19 May 2023 13:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjESLo7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 May 2023 07:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjESLo7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 May 2023 07:44:59 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746FDF3
        for <live-patching@vger.kernel.org>; Fri, 19 May 2023 04:44:58 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a640c23a62f3a-96f7377c86aso67192966b.1
        for <live-patching@vger.kernel.org>; Fri, 19 May 2023 04:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684496697; x=1687088697;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CmlwvXEoimVTfsyyyYai0GQlqo3zzXGhdH5Gfvmx5TY=;
        b=nRFy5voOOdc8uKNzq3KKp2GIsLflfB1DoyK0HLfuQh9kWFTRfkLvg3KWiNb3WTkBCa
         k6tn2GeBaIK7wi8GRuXf0ug0uWU4ZgNKcV81zQ1bCQe0a0ovEKm6EQIDaL/acgL9rsk6
         Ov7ksDbzhDF41nxgJb/WdwuR/fDADtNm+aL/SUycYTUD7HA5Vp3ugUm78ziIw9Ovk4dT
         cHkGss2CkYeVpuSIFcCmK8f7s6h7uMTbiJFu4IwNhy2Pfehc4pk/Gf+wfDucnxHXgcc3
         bcE4VBEjIP8LAIF7jGEriZvsi3z2RN/4ZZuXRRZXDmZ+vsXGPufmRUsi/MN1hMIIi0Ix
         qKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684496697; x=1687088697;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CmlwvXEoimVTfsyyyYai0GQlqo3zzXGhdH5Gfvmx5TY=;
        b=gAJv7g1BWNTeN/LucgjaZ1RpGs1tEDp7l6MnaT8XRMhyWTkBdqhJYbzG1RJjGRJd0W
         uSZJDmKFBODVuCzWhYsoFUpp8tinL2ScV18QzuMeD4JZ7m/xWJlV7l7rP6x69q6vZ+q6
         1nEbjkm4XsL0dwVYitJhBTKytWKAyPd4QHpTb02n7YQmW/3xD3Ank5oBRD2rwVHgdmo4
         4jvBaG4LdN4xIzIyIE8+YcwvxQPwllVELmSPVxxaBEhJZhnAPxLS5yNlWdZCzsDikoWw
         CwMgz2zNAiHRQ0s6jaIdoFk1ka0dRhgpbiDhhTjjk15Ptm5wmBSjOVc9GyDa+g0YgH21
         0LpA==
X-Gm-Message-State: AC+VfDxZgv1ZpkkeB146wPasTfBNMsRZZyL4SlH+/6yn4QAsXcAW9iAi
        s+MvlX/rEpq/lsVUC8qaqxqkoipSq0OwrrTAf20=
X-Google-Smtp-Source: ACHHUZ5f8fk5rfQI/DFvWDOYGGpuCiKByE6DsgiP9Tn9Zr+wsvIobEXR8MHteb5xYszOcTwi9ah6+dPIQV0YtN8eixI=
X-Received: by 2002:a17:907:7647:b0:94e:9a73:1637 with SMTP id
 kj7-20020a170907764700b0094e9a731637mr1541249ejc.75.1684496696761; Fri, 19
 May 2023 04:44:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6f02:8496:b0:4b:d4d6:3969 with HTTP; Fri, 19 May 2023
 04:44:55 -0700 (PDT)
Reply-To: ninacoulibaly03@hotmail.com
From:   nina coulibaly <coulibalynina107@gmail.com>
Date:   Fri, 19 May 2023 04:44:55 -0700
Message-ID: <CA+4vKakLPav567XMB4e=E3DYoJ=OhjT3+LWByGq=j8YSuw_eOw@mail.gmail.com>
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

Please grant me the permission to share important discussion with you.
I am looking forward to hearing from you at your earliest convenience.

Best Regards.

Mrs. Nina Coulibaly
