Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3222FE14A
	for <lists+live-patching@lfdr.de>; Fri, 15 Nov 2019 16:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfKOPc5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Nov 2019 10:32:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727566AbfKOPc5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Nov 2019 10:32:57 -0500
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F8EB20715;
        Fri, 15 Nov 2019 15:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573831976;
        bh=lF1pDBpWMtFPkQJeH2fsyeRqzp8k2ixrPriMYLAuYjo=;
        h=Date:From:To:cc:Subject:From;
        b=EjamhU9MOQmz1IYVR6Q6bh8jz5ihdM0jGKDpYOkmJd8oZs67eB+Jr7X9cPWqrE7Vn
         5i8OODGhL4dtIV3ytZws1A29kELEN+RcWwm+2LI3uDafQnytX0vFHnAcCklpK1n92Z
         ZzLgVKwKS+CHKRGvpGcIMRB5V+m1Ca46VSwSEoQs=
Date:   Fri, 15 Nov 2019 16:32:52 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Nicolai Stange <nstange@suse.de>, Miroslav Benes <mbenes@suse.de>,
        Petr Mladek <pmladek@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>
cc:     live-patching@vger.kernel.org
Subject: Summary of LPC 2019 live patching miniconf
Message-ID: <nycvar.YFH.7.76.1911151630420.1799@cbobk.fhfr.pm>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

the summary of the livepatching miniconf that happened on LPC 2019 in 
Lisbon earlier this year is now online at:

	https://linuxplumbersconf.org/event/4/page/34-accepted-microconferences#lpatch

-- 
Jiri Kosina
SUSE Labs

