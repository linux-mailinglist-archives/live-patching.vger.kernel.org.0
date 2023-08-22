Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A232784F68
	for <lists+live-patching@lfdr.de>; Wed, 23 Aug 2023 05:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbjHWDms (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 22 Aug 2023 23:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbjHWDm3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 22 Aug 2023 23:42:29 -0400
Received: from symantec4.comsats.net.pk (symantec4.comsats.net.pk [203.124.41.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E3BE4D
        for <live-patching@vger.kernel.org>; Tue, 22 Aug 2023 20:42:21 -0700 (PDT)
X-AuditID: cb7c291e-06dff70000002aeb-92-64e56b34f719
Received: from iesco.comsatshosting.com (iesco.comsatshosting.com [210.56.28.11])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by symantec4.comsats.net.pk (Symantec Messaging Gateway) with SMTP id CB.B1.10987.53B65E46; Wed, 23 Aug 2023 07:13:09 +0500 (PKT)
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns;
        d=iesco.com.pk; s=default;
        h=received:content-type:mime-version:content-transfer-encoding
          :content-description:subject:to:from:date:reply-to;
        b=OakzZDGO7y860k5lsi5BDIiEFsVQBzwH2YVhoXwt10JX725nBbCh9t7tOopd3CRB3
          9TzaGgVXsBVFJtm1GyTUJuXL+F9cnB9x2kUULHr46YPOyV1RgQZ3NbTPDkxC/JgP5
          4PJrOY5kMhofWYoRmvj43NwxLirNDb4imbLGx9d7w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iesco.com.pk; s=default;
        h=reply-to:date:from:to:subject:content-description
          :content-transfer-encoding:mime-version:content-type;
        bh=GMzYzcyTxDsE6wX/XHG6MHqAdAiHrhqbmmLQ/TZ1QnQ=;
        b=ETCitrAqeuKUEHfCVzZHRCVTPpU8C0qStOLwhdZwWkvnjPOasogB6h38IFj8UK4nb
          c+COIfKC/ZUToGjRrPTI/ss8nN6V6+Vb8y0KqDDF7lZpYhy284T+vN/VJBMX104Eg
          yKwGnhZuzyEmK04psvk7CuyuNvEHrOoh+vrKvwGlg=
Received: from [94.156.6.90] (UnknownHost [94.156.6.90]) by iesco.comsatshosting.com with SMTP;
   Wed, 23 Aug 2023 04:32:37 +0500
Message-ID: <CB.B1.10987.53B65E46@symantec4.comsats.net.pk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re; Interest,
To:     live-patching@vger.kernel.org
From:   "Chen Yun" <pso.chairmanbod@iesco.com.pk>
Date:   Tue, 22 Aug 2023 16:32:51 -0700
Reply-To: chnyne@gmail.com
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVyyUKGW9c0+2mKwYZtIhZnDt5jc2D0+LxJ
        LoAxissmJTUnsyy1SN8ugStjyboLLAW7mSva+hexNDA+Zupi5OSQEDCR+Lh0F3MXIxeHkMAe
        Jom7xz4xgjgsAquZJdYevQblPGSW6F71D6qsmVHiyZE/jCD9vALWEheuHmIGsZkF9CRuTJ3C
        BhEXlDg58wkLRFxbYtnC10A1HEC2msTXrhKQsLCAmMSnacvYQWwRAUWJ5fcvsoLYbAL6Eiu+
        NjOClLMIqEpsuW8AEhYSkJLYeGU92wRG/llIls1CsmwWkmWzEJYtYGRZxShRXJmbCAy1ZBO9
        5Pzc4sSSYr281BK9guxNjMAwPF2jKbeDcemlxEOMAhyMSjy8P9c9SRFiTSwD6jrEKMHBrCTC
        K/39YYoQb0piZVVqUX58UWlOavEhRmkOFiVxXluhZ8lCAumJJanZqakFqUUwWSYOTqkGxtll
        KsknjggLvlu/nX/da++fq3cHX99uJb3/wWYWF3fVW0/ktSd+fneiaLXmQ5UJiv+yPotKFRmf
        036fyzJ3R++iAo7Lt/sZBFe7pDTsPPn369YXs2fUHJBYH8Oj/iCQWU563eOZmS4XD9z//mje
        W2m5VQfvq957PV/sTHysUsTdmh0z/z4PW6qhxFKckWioxVxUnAgAFLZWxz8CAAA=
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        RCVD_IN_DNSWL_LOW,RCVD_IN_SBL,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was
        *      blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [URIs: iesco.com.pk]
        * -0.7 RCVD_IN_DNSWL_LOW RBL: Sender listed at https://www.dnswl.org/,
        *       low trust
        *      [203.124.41.30 listed in list.dnswl.org]
        *  0.1 RCVD_IN_SBL RBL: Received via a relay in Spamhaus SBL
        *      [94.156.6.90 listed in zen.spamhaus.org]
        *  3.3 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Re; Interest,

I am interested in discussing the Investment proposal as I explained
in my previous mail. May you let me know your interest and the
possibility of a cooperation aimed for mutual interest.

Looking forward to your mail for further discussion.

Regards

------
Chen Yun - Chairman of CREC
China Railway Engineering Corporation - CRECG
China Railway Plaza, No.69 Fuxing Road, Haidian District, Beijing, P.R.
China

