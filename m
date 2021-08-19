Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28E13F16F1
	for <lists+live-patching@lfdr.de>; Thu, 19 Aug 2021 12:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbhHSKCi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 19 Aug 2021 06:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237662AbhHSKCi (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 19 Aug 2021 06:02:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 706116112E;
        Thu, 19 Aug 2021 10:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629367322;
        bh=idegbPN8T/Au0Wc8vQSJ6Iqm+J7jP04/1r9PJ8PQMqw=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=rYpqpnyQ+Ph7+139UfRQ9JpgsuQBpVA29iY1eUQmywGi2In5l2R6eVseNCUt9az27
         j0yDqayvr+dk3Mh9Y5kGOecUQpTdcI7qa5mXTLNMTGOEFZ649Gcm0T3OwsyoJ6lCMj
         dCKgIeJorCDv305Q5AlnNSvKDGP+nNVzLewJyEdni0tuD3G+8G2BpLwkk4AGTpTVFp
         3Y7OT6L7M8PQ2weQoD9L/iS3X0NyUbn4eVnybF9uvPJ7acpvGuAjMvogpLzeEgIHax
         KaEr1oqY/kq+k1vQ2AZcwa2MaNjvIJRtX0C9aphbgFHAXVI0Z0dU3roi2N/+4B04xW
         BdQ2RuZRDs57w==
Date:   Thu, 19 Aug 2021 12:01:51 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 26/38] livepatch: Replace deprecated CPU-hotplug
 functions.
In-Reply-To: <YQpHTrUqO/VtyqZG@alley>
Message-ID: <nycvar.YFH.7.76.2108191201120.15313@cbobk.fhfr.pm>
References: <20210803141621.780504-1-bigeasy@linutronix.de> <20210803141621.780504-27-bigeasy@linutronix.de> <YQpHTrUqO/VtyqZG@alley>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 4 Aug 2021, Petr Mladek wrote:

> > The functions get_online_cpus() and put_online_cpus() have been
> > deprecated during the CPU hotplug rework. They map directly to
> > cpus_read_lock() and cpus_read_unlock().
> > 
> > Replace deprecated CPU-hotplug functions with the official version.
> > The behavior remains unchanged.
> > 
> > Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> > Cc: Jiri Kosina <jikos@kernel.org>
> > Cc: Miroslav Benes <mbenes@suse.cz>
> > Cc: Petr Mladek <pmladek@suse.com>
> > Cc: Joe Lawrence <joe.lawrence@redhat.com>
> > Cc: live-patching@vger.kernel.org
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>

As this doesn't seem to have been picked up yet, I've just applied it to 
livepatching.git#for-5.15/cpu-hotplug

Thanks,

-- 
Jiri Kosina
SUSE Labs

