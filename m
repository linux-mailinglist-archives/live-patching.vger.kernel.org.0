Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA5739DD4D
	for <lists+live-patching@lfdr.de>; Mon,  7 Jun 2021 15:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhFGNK5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 7 Jun 2021 09:10:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230194AbhFGNK4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 7 Jun 2021 09:10:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623071344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H2K8Jw3CiaykrguwZiAlFM0Svs+MuPSnZvZJ7a9wNHQ=;
        b=iJqmRFHNUtm6/NmAfqlv3wKGBNOlY/5aytIs1Agle4qzIrqlpwLPMKtg6qsCqIXt8bdA2Z
        jrPctI3wtXbPDrnqn6c+63BleD7PzGkdHL4J5s4nfQRRmh+mSBQVYpEOdCc2WojVQgUhgC
        6gtGh/vrC+hXiccRgmI+Yp64blbOfGE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-SxdSqh9bOBCCdrG4RjsFmg-1; Mon, 07 Jun 2021 09:08:59 -0400
X-MC-Unique: SxdSqh9bOBCCdrG4RjsFmg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C392501E5;
        Mon,  7 Jun 2021 13:08:57 +0000 (UTC)
Received: from redhat.com (ovpn-113-26.rdu2.redhat.com [10.10.113.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1754160C17;
        Mon,  7 Jun 2021 13:08:53 +0000 (UTC)
Date:   Mon, 7 Jun 2021 09:08:52 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Suraj Jitindar Singh <surajjs@amazon.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, catalin.marinas@arm.com,
        will@kernel.org, broonie@kernel.org, madvenka@linux.microsoft.com,
        duwe@lst.de, sjitindarsingh@gmail.com, benh@kernel.crashing.org
Subject: Re: [RFC PATCH 1/1] arm64: implement live patching
Message-ID: <YL4aZCMmouLCQlJr@redhat.com>
References: <20210604235930.603-1-surajjs@amazon.com>
 <20210607102058.GB97489@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607102058.GB97489@C02TD0UTHF1T.local>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jun 07, 2021 at 11:20:58AM +0100, Mark Rutland wrote:
> On Fri, Jun 04, 2021 at 04:59:30PM -0700, Suraj Jitindar Singh wrote:
> > It's my understanding that the two pieces of work required to enable live
> > patching on arm are in flight upstream;
> > - Reliable stack traces as implemented by Madhavan T. Venkataraman [1]
> > - Objtool as implemented by Julien Thierry [2]
> 
> We also need to rework the arm64 patching code to not rely on any code
> which may itself be patched. Currently there's a reasonable amount of
> patching code that can either be patched directly, or can be
> instrumented by code that can be patched.
> 
> I have some WIP patches for that at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/patching/rework
> 
> ... but there's still a lot to do, and it's not clear to me if there's
> other stuff we need to rework to make patch-safe.
> 
> Do we have any infrastructure for testing LIVEPATCH?
> 

Hi Mark,

If you're looking for a high level sanity check, there are livepatching
integration selftests in tools/testing/selftests/livepatch.  Let me know
if you have any questions about those.

Regards,

-- Joe

