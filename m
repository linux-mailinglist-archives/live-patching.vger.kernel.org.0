Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A321934898F
	for <lists+live-patching@lfdr.de>; Thu, 25 Mar 2021 07:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhCYG5M (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Mar 2021 02:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhCYG5B (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Mar 2021 02:57:01 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E55C06174A;
        Wed, 24 Mar 2021 23:57:01 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id q12so660990qvc.8;
        Wed, 24 Mar 2021 23:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uz6+kiBviuADJ12mOaLUJGMa1maUKwbLwzWTG0awX6g=;
        b=aPtolmZMXtgEMHeNL0W2eAbipeKtb1wiB54OMg1wru+cRPm9lLuR0SvSLB6tFX5ghG
         j+RbM6F+3f8iiOnuxQJlr9Wrn7o9y0r8bMoKYDP1+MRlSjPyTfNmrrt+IFAxe2pfze+3
         WRRfsnfWWcvYK+ZbmJ1TXLH3ahjDmrVD198y6Bdx2Qu7GUcGaSkAyrHl3HPAwAQZGDfe
         Ivas5jUwbBXssDO//8I/A9Xs5vqujpgp5tzCl+6rjY8e+tEbtOApgZIWB+AOPaz2BXcf
         VdZkZ6LUcviJAVAxKqINDBnkGcivgjylHtK0JfAG3sRBPdDzw7FGl2d5aAF4uk3FdlwO
         PpHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uz6+kiBviuADJ12mOaLUJGMa1maUKwbLwzWTG0awX6g=;
        b=m5DIkJSpRiTWvQMbVdZpsDuzrnx+0vQ0Fs6Ocqbyl0gU6jiKQOe9JFZbIjg/CRf4SW
         AguSQTAKjdeU/dQh2hbfczx5MbyNKIW5TnYq8B+D3g4cav+Hh+5HCAN09o9H3HZ2MGCM
         Up7We8QMIzKOpb8vglbq6Rb0SRDLQ4ry1RPlyEHRm9pfkpla8d6NdPUDECUEcu1xo/P8
         xUC52LozRysg4DIIFouUhl3E35jQsJWrVDYNWTH38mZeptTJKv4Vv9dglqAL2YkoKtZ4
         thTuKOGgMcUao/NRBdDMjiYizIOzvwAX+LglNRYxJ9rBh5Fwq6oC4sR4ddEfmlnrSKbp
         lpdg==
X-Gm-Message-State: AOAM530qkBTK/++dMRymhSSf0CrYpdB1s8F2W4oggBaFrp0eGpxSRsYa
        gPduWIgD+275XjoQm5nGMN8=
X-Google-Smtp-Source: ABdhPJwTHT9EKSzEHs1YGEdnDQj+8CaWntlEw6epe6B1bt0olFY77jYP/IYCbR34li588SrnFkb70A==
X-Received: by 2002:a05:6214:10ca:: with SMTP id r10mr48944qvs.53.1616655421128;
        Wed, 24 Mar 2021 23:57:01 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.54])
        by smtp.gmail.com with ESMTPSA id a138sm3532591qkg.29.2021.03.24.23.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:57:00 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com, corbet@lwn.net,
        live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] docs: livepatch: Fix a typo
Date:   Thu, 25 Mar 2021 12:26:46 +0530
Message-Id: <20210325065646.7467-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


s/varibles/variables/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 Documentation/livepatch/shadow-vars.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/livepatch/shadow-vars.rst b/Documentation/livepatch/shadow-vars.rst
index c05715aeafa4..8464866d18ba 100644
--- a/Documentation/livepatch/shadow-vars.rst
+++ b/Documentation/livepatch/shadow-vars.rst
@@ -165,7 +165,7 @@ In-flight parent objects

 Sometimes it may not be convenient or possible to allocate shadow
 variables alongside their parent objects.  Or a livepatch fix may
-require shadow varibles to only a subset of parent object instances.  In
+require shadow variables to only a subset of parent object instances.  In
 these cases, the klp_shadow_get_or_alloc() call can be used to attach
 shadow variables to parents already in-flight.

--
2.30.1

