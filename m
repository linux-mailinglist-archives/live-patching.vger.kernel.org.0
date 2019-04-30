Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E5E1028A
	for <lists+live-patching@lfdr.de>; Wed,  1 May 2019 00:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfD3Wkg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 18:40:36 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46365 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbfD3Wkf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 18:40:35 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id B97612329E;
        Tue, 30 Apr 2019 18:40:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 30 Apr 2019 18:40:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tobin.cc; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=uSxjqNftJ9OpafDOpoXJOCCkS+q
        PtA+kvIr1Yk5mjnU=; b=OVblrJdIh9NfZAks9MSGdeTlodHm49AyY2o11wxi710
        n3/+hM8UM0DLZjBqBfvIflQWqVD1brVvxGCdQMMg5CG83sRX3OTubzXPilqhPljg
        fJDhQXHVRMwe0rWKcx+Bd0rBEB/oGGxlZNdH6hxvYGlO9bxsqarIuFYeCy+rd4em
        yYbPWXTr9ih200bXgEQdD4zOMROiTk/N2NclJd2Vmw4DDVzdRKyd+czThEUG5TZE
        sfD1tDEiepc4VsIf1YbP8Dx92YbyJofywbpC9TE1gtA0I0aI/nsLZo8alQBXoiXv
        OGgSoYzkaaj+dw3vWpV1YHfUVtlPDYm7IPKXf0U55lg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uSxjqN
        ftJ9OpafDOpoXJOCCkS+qPtA+kvIr1Yk5mjnU=; b=U8r20nCq5Ym2C6mmddce/E
        nK7Js5/U+3l4k/+6ficF1l3c42PsXmZbVoRUrbJQuZjWrz/Fv5qgDBcJI2rXfI98
        pWH/10DOwpXtPV3N8626w9a3ULwoI9jfmeETK9J642xAMGiIIs6eSrgQpV4LTlFQ
        gezJquUfpMdu9fPcBG+N3hSpZKr45BWgc/Sost6CuoEVOTQOr8BQnpDjMX960Tnm
        ypGVN9QxUMuz3eSqSRXqyKJEJJOBoWHyuCc8maH5/YNnWMlu6iP768e05pabKPSz
        Ax/N6lfrV6VaT5CrgXcA5EBIfhSaWFRMNSnryP3qVOc1o/G3hLknC6T6efibbycw
        ==
X-ME-Sender: <xms:4s7IXEUIdiynEnnSqmnGdcfxX3Qv8FIcumEky_iMZuKLj0WDxbZ4cQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieeigddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhepfffhvffukfhfgggtuggjofgfsehttdertdfo
    redvnecuhfhrohhmpedfvfhosghinhcuvedrucfjrghrughinhhgfdcuoehmvgesthhosg
    hinhdrtggtqeenucfkphepuddvuddrgeegrddvtdegrddvfeehnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehmvgesthhosghinhdrtggtnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:4s7IXDzBSj8xwHlJJmYrq0S8vrumP5Svw1D5GxpQvRF-0QfxMJJ4Kw>
    <xmx:4s7IXMOs-IPcdUSoCXtgk2BSAvGH0HoZ87RvEOny10FRMV9i_cWtEw>
    <xmx:4s7IXNrGidhUELoO5k2sST02ZEY8lokNo_vvzOoVtOCZDD3hSVt93w>
    <xmx:4s7IXNuw2nd_sVz00w7z3D1W1uP3m1uelAKhLRZ_7pKyyIBLk3zeOA>
Received: from localhost (ppp121-44-204-235.bras1.syd2.internode.on.net [121.44.204.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A6E8103CA;
        Tue, 30 Apr 2019 18:40:32 -0400 (EDT)
Date:   Wed, 1 May 2019 08:39:57 +1000
From:   "Tobin C. Harding" <me@tobin.cc>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: Fix kobject memleak
Message-ID: <20190430223957.GF9454@eros.localdomain>
References: <20190430001534.26246-1-tobin@kernel.org>
 <20190430001534.26246-2-tobin@kernel.org>
 <20190430084254.GB11737@kroah.com>
 <alpine.LSU.2.21.1904301235450.8507@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1904301235450.8507@pobox.suse.cz>
X-Mailer: Mutt 1.11.4 (2019-03-13)
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 30, 2019 at 12:44:55PM +0200, Miroslav Benes wrote:
> On Tue, 30 Apr 2019, Greg Kroah-Hartman wrote:
> 
> > On Tue, Apr 30, 2019 at 10:15:33AM +1000, Tobin C. Harding wrote:
> > > Currently error return from kobject_init_and_add() is not followed by a
> > > call to kobject_put().  This means there is a memory leak.
> > > 
> > > Add call to kobject_put() in error path of kobject_init_and_add().
> > > 
> > > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> > 
> > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Well, it does not even compile...

My apologies, I did compile this but obviously I don't know how to
configure the kernel.

Thanks for the review.

	Tobin
