Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFA48D1F0
	for <lists+live-patching@lfdr.de>; Wed, 14 Aug 2019 13:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfHNLQ6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Aug 2019 07:16:58 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33812 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfHNLQ6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Aug 2019 07:16:58 -0400
Received: by mail-lj1-f195.google.com with SMTP id x18so7970907ljh.1
        for <live-patching@vger.kernel.org>; Wed, 14 Aug 2019 04:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mM+lOG3uuaZKO9SiLPdJ+4deUlKV/b5HbUdj3Mc9GeI=;
        b=DyZlW9rEyj+EVzbT42xD4GrOCx8/nZME5s1x9ubtqPvmzO3OboHv2sJX6yUbEIHv8I
         VJeZOl5WCXgmjaoXlMtr+GU4OSoVo9m2HdDGg6ma9v7dv79kZXAa4eHOQPkPavbyFn+Z
         LmVee68sPKqFRaEehadGBa9OSzLoWu7goRFs3nf90Wxg/kHBHrXxSYTK2wndU3zORTkC
         UOX8E2oWqHFTJiazrI7Xv40sqBbRdSViRNeSDBSnoVsXQ7AQPJetvC21HTDU5G1LhGog
         +VaFBgwg0tdww7ZnKwLqt5Xh0O3zHbQuTmDdkfFTDpbkiN7jrd14O5xaxAP3SkOnv2MU
         pBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mM+lOG3uuaZKO9SiLPdJ+4deUlKV/b5HbUdj3Mc9GeI=;
        b=bxqvV2dsJvKpEO3mXt528740JduluYo4/SP40nNPwTWJIvSn4zRUkLWKi2BXqOfBCo
         LabxCyG0xyxjvj5n8xkT+Ar4MC1rCfwY0sZeV5Tr9OoiSI+UT/qCvPhjk6rQt3/Z798k
         tgBFR56RfvbGbR0IXENA7I2603fP6M/a+hrNr123nVCbghQC04auBt4yvFUz2s0Q9u2F
         eXAJtvtX+ANrMon8QTqRemybqV6GWR9G4CbjKpPsg24nQrDnijMNfbSDBvdD0bbw8h4j
         Ssrb5tCSUa+rEvmuVOSayVNa/HSRAJSB0Cji7DMfTzhz3uDwNQ4VPmWLrTatG5gix2R3
         PAFA==
X-Gm-Message-State: APjAAAXOep+ucIj+f/EBumUW2CqAZg1jBP4tyT+3Y5tTe8/T8NlGDi9G
        RTtNjylzWew6hTQ47RqsIG0/XVUHZRZ+Ew==
X-Google-Smtp-Source: APXvYqyE6JOL4CkL17m8OpVNbigSqpiZyVfokme8qoKLjA4Eav66jqxj/Jm39QFjJRx7gKdhbyUEew==
X-Received: by 2002:a2e:9e81:: with SMTP id f1mr24935605ljk.29.1565781416360;
        Wed, 14 Aug 2019 04:16:56 -0700 (PDT)
Received: from localhost (c-243c70d5.07-21-73746f28.bbcust.telenor.se. [213.112.60.36])
        by smtp.gmail.com with ESMTPSA id q24sm2004302ljc.72.2019.08.14.04.16.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 04:16:55 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     shuah@kernel.org, pmladek@suse.com, mbenes@suse.cz,
        jikos@kernel.org, jpoimboe@redhat.com
Cc:     live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] selftests: livepatch: add missing fragments to config
Date:   Wed, 14 Aug 2019 13:16:51 +0200
Message-Id: <20190814111651.28433-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

When generating config with 'make defconfig kselftest-merge' fragment
CONFIG_TEST_LIVEPATCH=m isn't set.

Rework to enable CONFIG_LIVEPATCH and CONFIG_DYNAMIC_DEBUG as well.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 tools/testing/selftests/livepatch/config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/livepatch/config b/tools/testing/selftests/livepatch/config
index 0dd7700464a8..ad23100cb27c 100644
--- a/tools/testing/selftests/livepatch/config
+++ b/tools/testing/selftests/livepatch/config
@@ -1 +1,3 @@
+CONFIG_LIVEPATCH=y
+CONFIG_DYNAMIC_DEBUG=y
 CONFIG_TEST_LIVEPATCH=m
-- 
2.20.1

