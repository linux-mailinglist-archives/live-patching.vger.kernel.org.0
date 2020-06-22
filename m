Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B26203BE5
	for <lists+live-patching@lfdr.de>; Mon, 22 Jun 2020 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgFVQCo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 22 Jun 2020 12:02:44 -0400
Received: from sonic310-24.consmr.mail.ne1.yahoo.com ([66.163.186.205]:38614
        "EHLO sonic310-24.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729851AbgFVQCn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 22 Jun 2020 12:02:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1592841762; bh=cK2qy9Lv5SAgMg9nAvfVmkJPj46H3ss3vOVyjpHm6Nk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=pj4oXOE2OyHYdknQwXt6M/Ur0kBv147g1Kmcf7tcKmW6vP7QkIs/0Ep6iSdvVbItbqmxz5qvNv2Knn1CCHx1JXfWNGArujlCeYSuykFkZJxjCzXbA8w0wLvpau2QmrFe2PrXbdJtSp7sZvV+Fn+MSxxEAMjJwUYy035jS7THEfRj7uQyYShNvBfOmlxWp2S02TFvKY3T8mKwBfr51HZEWkQMAbMayIdgv5piHcdL/TZX2mXpkwvJPu8ioALMGRwKiiqoZPpjEvgEgk393Eu5ga4kGIVQY4hlCVIOpCvBFLDvIoZ1lAST79npmmV4flo+Zn04KnSvOcS2Gzu1cuLEgg==
X-YMail-OSG: SBQnKXIVM1mTNgCK3zLXZz0mAqCLAu_qYFGTOP1_.16Lsm0yAbmVuUiRbzcAPRx
 vFd64NNq0aBErGk8jZQmppt557BbRNs40UvRgt28TV6psc53_bk_.g63XmJg2TkYReecI3VnjPsk
 vju7RXS_pQjXBebXy5sx0mNpmwNtjf7jE8lIrTc8fGjR0sYWzBYOY4pHHnM.7Lauc3pLU2rqmfq.
 N7Eit2GLqPlx80aoZ9B84PI5p3X1w6hee3o5FcuQFao_7h1_YXe_MfCcrR.gA1nwVxWyYYHuZUlo
 KB7qFK6lyMf4FYzujm8bcK.NiCMUKrpWEcnHWksbbt9Lidz3yAVXOZ1DOCm2iJZVhfBqB90PWDdD
 h9DjnulgZkLSenlO3C4dAuGFDD70yrVPPubueGjAmM0VCHZkyGbtX4g9G9ELFZ0rfJAWVeCrntaJ
 XaP_CoyrETUNdsTiKKKrLFuFdLIhozHA4a9YaA3ECDZQJcSRzNTD.tKwjjQ_7Yw1BwQ_7NdJPUKY
 yaaZU_NqX5rmJ3eOWg.8QmQ0HNdNbxjHkrCRz5wTMoxSSrmcKke4bGYKz.EHuPpXSr1zn2RBZrqn
 0jivrLuvPfq1ve7lQAwBnuycFHVXUVpNHIaX5hcOm8QQ_uWM_9ddO_MgB1mRbgBrOT5v2LfWivzh
 AIjUglErrBFUtol1mHqzoU4Y3yqpEd1xqtTUvJKl4emys_ReYiECF5UFCnt0.U6q.leVTajuX1ut
 CpUrzbOXptEgtWupy64dMHIXwDCONaj2q7iNyI289LiZatE6zPKi4nsl_7Uig2CFqiqY35ypdg45
 vL3S8mRwuJYQSBlCWVwW6FLdKvoJP1KT8kzHpkeOhqpIeXXPVO96fLi5gHRH_vcRbKCB5b.BrOyt
 qBu_hRvFPBbweIXJHLEdIUxsusdFvM3.V0Im6IpQN1SPaG.hkbdS9Vv.0uVcQnH2OgItiTskowjj
 GGFcGVYA8FFmbLVWVJGIyYCpshqNp7PujWUFrYuVnMHPHmrjFdKOwc85CX7SBwGI86eny_IcdNEy
 ulKoRKDpCZOpfZdoCF_uJY6oWCtHdhthdlC1E0pmFjMadzzuvN0DhIAxEFdT_LxHuG4kDeoEmUFj
 KND82BquRO.SJnAaTVZSmG5DktRTx5DjQmMl.agQCbe6XpJqssdIfCnjU3SrWVrQ0C8HJbqKyJFN
 3zq6LevTDXZ82iM1gRZIyhjWzD3WCk78Tg.K.mHveW2E5gTCIBBzx1f_4iMXufrf2M8GQ.KFDB8R
 irEjMrrOq2MPQdOh8jzM5g0pA6w4rrjQajW2nEKfW7COn7pVCPueyyketOuFwvj.0NSx3dDesGg-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Mon, 22 Jun 2020 16:02:42 +0000
Date:   Mon, 22 Jun 2020 16:02:39 +0000 (UTC)
From:   Karim Zakari <kariim1960z@gmail.com>
Reply-To: kzakari04@gmail.com
Message-ID: <941580334.1864237.1592841759009@mail.yahoo.com>
Subject: URGENT REPLY.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <941580334.1864237.1592841759009.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16138 YMailNodin Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



Good-Day Friend,

 Hope you are doing great Today. I have a proposed business deal worthy (US$16.5 Million Dollars) that will benefit both parties. This is legitimate' legal and your personality will not be compromised.

Waiting for your response for more details, As you are willing to execute this business opportunity with me.

Sincerely Yours,
Mr. Karim Zakari.
