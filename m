Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CDF1B7712
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2020 15:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgDXNhV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Apr 2020 09:37:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28744 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726301AbgDXNhV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Apr 2020 09:37:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587735440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4p9xE6dDL4DwA5J4m+c63Sg1xaDNlwCwqGVVFWe5OKA=;
        b=PQbXocizU75QK5CRHCySK/+cukRQ3I+cLGIUKNj2AfwO7kx8EthknjnzclfIpekq0+il/0
        WhjZmP0/cIBW61WHD2z21u5y2/M8wpOuyiF9jqFxHwsJAjbZUZRV0OOp6T0SDQ3IZzw+rH
        gvorvbVED4kIiWTHSv3AANq+Cu+M3fA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-PGQFGcJnM42jROWMNDQS9Q-1; Fri, 24 Apr 2020 09:37:19 -0400
X-MC-Unique: PGQFGcJnM42jROWMNDQS9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4838A8B8C96;
        Fri, 24 Apr 2020 13:37:17 +0000 (UTC)
Received: from treble (ovpn-118-207.rdu2.redhat.com [10.10.118.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 011E599DE;
        Fri, 24 Apr 2020 13:37:11 +0000 (UTC)
Date:   Fri, 24 Apr 2020 08:37:09 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, Vasily Gorbik <gor@linux.ibm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v2 6/9] s390/module: Use s390_kernel_write() for late
 relocations
Message-ID: <20200424133709.egffplf3ewrc4leg@treble>
References: <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
 <20200422164037.7edd21ea@thinkpad>
 <20200422172126.743908f5@thinkpad>
 <20200422194605.n77t2wtx5fomxpyd@treble>
 <20200423141834.234ed0bc@thinkpad>
 <alpine.LSU.2.21.2004231513250.6520@pobox.suse.cz>
 <20200423141228.sjvnxwdqlzoyqdwg@treble>
 <20200423181030.b5mircvgc7zmqacr@treble>
 <20200423232657.7minzcsysnhp474w@treble>
 <eb464a0b-922b-1dbd-81e6-1161a5157acb@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eb464a0b-922b-1dbd-81e6-1161a5157acb@de.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 24, 2020 at 09:20:24AM +0200, Christian Borntraeger wrote:
> > Here's a fix, using write() for the PLT and the GOT.
> 
> Are you going to provide a proper patch?

Yes.  These incremental patches are intended to be part of the
discussion, feel free to ignore them.

-- 
Josh

