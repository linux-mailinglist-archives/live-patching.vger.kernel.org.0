Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331BB1BC169
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2020 16:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgD1OfZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Apr 2020 10:35:25 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39013 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726868AbgD1OfZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Apr 2020 10:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588084524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F96PyL36Ha2IVU32KX1LippQ8yrfgUGzD5zDTwJrRB0=;
        b=KFrle0MIvPTxS+Gqq/DvgW0wwCx1hYvrWk6b8F2Urp/Mh55MDA1s4qNd6EL9QMBCi+gizg
        1O6qG7EdCPnhBxmgLma5Bs3vcBHvoIA+AJZ2Zw2K4DMcfEoolX8kPkC4oVLLOhfBe3zKzZ
        hXAWbs9xsUlMoIriBGPuSE1uCXfPEaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-2PmHhfDZPTO3mZISgOz6pQ-1; Tue, 28 Apr 2020 10:35:20 -0400
X-MC-Unique: 2PmHhfDZPTO3mZISgOz6pQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C50984B8A2;
        Tue, 28 Apr 2020 14:35:19 +0000 (UTC)
Received: from treble (ovpn-112-209.rdu2.redhat.com [10.10.112.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3C0119C58;
        Tue, 28 Apr 2020 14:35:15 +0000 (UTC)
Date:   Tue, 28 Apr 2020 09:35:13 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v3 00/10] livepatch,module: Remove .klp.arch and
 module_disable_ro()
Message-ID: <20200428143513.bnqaa2t2fqlat6yy@treble>
References: <cover.1587812518.git.jpoimboe@redhat.com>
 <alpine.LSU.2.21.2004281541420.6376@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2004281541420.6376@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 28, 2020 at 03:48:58PM +0200, Miroslav Benes wrote:
> 
> With the small issue in patch 2 fixed
> 
> Acked-by: Miroslav Benes <mbenes@suse.cz>
> 
> Great stuff. I am happy we will get rid of the arch-specific code.

Thanks!  Good catch with the bad rebase.  I'll fix it up with another
revision.

-- 
Josh

