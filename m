Return-Path: <live-patching+bounces-50-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC36E7FD7FB
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 14:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 292AF1C208C9
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 13:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE7620310;
	Wed, 29 Nov 2023 13:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fak4Gjx6"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D6B83;
	Wed, 29 Nov 2023 05:25:35 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1d01c45ffebso3369455ad.1;
        Wed, 29 Nov 2023 05:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701264335; x=1701869135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HWxBHhQIh0E6Mfd8BqEq+IhmKhUVNXmtyy9bRM7/+ak=;
        b=Fak4Gjx6QN+9obeEFVbES+8etRzW3aH/agkUWjChgV87e8soIfx4M/OJMH3FkxyDCt
         WWzKM/NLZ6IKO16iKVrJcKnK3YNREMUhSIVzOS8tQeHq9RG+QtXni/TqgcVjrc2L53+b
         AGoik9H3Ycn3FSOLV8/Q7O5MsHRG52mkA7ENMxbH6SOQtw1OS5Zp8/I2JMOU4VTz6xQq
         b1q3uzr1VOoWrVOTvucx0SCzsEFyxgGMuPHwGP1Ho5LnCCUCdOTBdVtwpZTit8vTZl1H
         jF/T3g6aSY96px8tdxV8XnQ7u2X1hkriaKOuXbrE9G4lGVK5blszUbcJENkCKbKMDge9
         D/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701264335; x=1701869135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HWxBHhQIh0E6Mfd8BqEq+IhmKhUVNXmtyy9bRM7/+ak=;
        b=puRBp72J9/L8yTYpvtrWCQhq+GSs9t+AWXWYh1B7lQZO8uOySCHCQGIcO/k6QL7jes
         YoudymLFxrkgFIIAWP+kjOTyVEMq03w2Cdt7NBMYf9cJ1nColruSzEepTeV77gf/ohJB
         9pCz6FhjknxGxqsvGTgy8O6aUWeBmOQKrgUprWSmHBrOKJDP75c7rfLJvREkjBmt56lW
         swBhtwDMYihKsyp0Pn/mU6CC9jMk99B/I/hXsAl++uOfQ438oiVa84odICUMhLWDsm3f
         ugDLts83rF3xzAtuVSNFP5CkutQIaq/UQF6fIRkPjkeqRBcXuyHfvqRWRIZRhQGdmRjw
         1mvQ==
X-Gm-Message-State: AOJu0YzQX7f+/rfjhOd7mxxXAStA6MO/gNcEX29gtiFUr+l3U2BSAow2
	/yr6roLYnttOZwC41FwuVpidFIE2UwvWrQ==
X-Google-Smtp-Source: AGHT+IFawD9MTreUWBiosITpCXfxYZlbFOQ5638LVOT6Eozt2lwiaFWRUcYnFlVe+nzPnluxSfsPIA==
X-Received: by 2002:a17:902:e88f:b0:1cf:cf40:3cef with SMTP id w15-20020a170902e88f00b001cfcf403cefmr9881616plg.64.1701264335246;
        Wed, 29 Nov 2023 05:25:35 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c08100b001ab39cd875csm10879553pld.133.2023.11.29.05.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 05:25:33 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 293C610205C7A; Wed, 29 Nov 2023 20:25:30 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Kernel Livepatching <live-patching@vger.kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Attreyee Mukherjee <tintinm2017@gmail.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 1/2] Documentation: livepatch: Correct "step on each other's toes" idiom
Date: Wed, 29 Nov 2023 20:25:26 +0700
Message-ID: <20231129132527.8078-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231129132527.8078-1-bagasdotme@gmail.com>
References: <20231129132527.8078-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1603; i=bagasdotme@gmail.com; h=from:subject; bh=r13kOykwe03xSnUVHKSLktQXQYt9cEeFqfNfS0XI6+0=; b=kA0DAAoW9rmJSVVRTqMByyZiAGVnO8LIj4CCHyBqemw2srUrOSh6W1CQt8FOHrGD57E6TXUq/ 4h1BAAWCgAdFiEEkmEOgsu6MhTQh61B9rmJSVVRTqMFAmVnO8IACgkQ9rmJSVVRTqNrFQEA25/K xny8zgv3Fsl0FAjX2IBTR7P/9wy/4yWjHbfqhPAA/R+AEfEjgRt+9q7vsq2RYJRSDJsPaSn+ZVO Ps9monoQD
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

The idiom is written as "step over" instead, which means walking over
something [1]; although it should have meant getting involved (interfere)
in each other redirection method's effect [2], as implied in the
surrounding context.

Correct the idiom.

Link: https://idioms.thefreedictionary.com/step+over [1]
Link: https://dictionary.cambridge.org/dictionary/english/step-on-toes [2]
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
I choose to keep the singular version of 'each other' since it refers to
individual redirection method (see [3] for grammatical explanation of why
it is the case ).

[3]: https://jakubmarian.com/each-others-vs-each-others-in-english/

 Documentation/livepatch/livepatch.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
index 68e3651e8af925..000059b3cbde49 100644
--- a/Documentation/livepatch/livepatch.rst
+++ b/Documentation/livepatch/livepatch.rst
@@ -39,7 +39,7 @@ and livepatching:
     are in any way modified.
 
 All three approaches need to modify the existing code at runtime. Therefore
-they need to be aware of each other and not step over each other's toes.
+they need to be aware of each other and not step on each other's toes.
 Most of these problems are solved by using the dynamic ftrace framework as
 a base. A Kprobe is registered as a ftrace handler when the function entry
 is probed, see CONFIG_KPROBES_ON_FTRACE. Also an alternative function from
-- 
An old man doll... just what I always wanted! - Clara


